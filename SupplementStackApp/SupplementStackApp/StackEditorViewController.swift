//
//  StackEditorViewController.swift
//  SupplementStackApp
//
//  Created by Nick Meyer on 3/20/22.
//

import UIKit
import Firebase
import FirebaseStorage

class StackEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var stackImage: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    
    private let storage = Storage.storage().reference()
    var imageURL:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpStyles()
    }
    
    func setUpStyles()
    {
        errorLabel.alpha = 0
        Utilities.styleFilledButton(uploadImageButton)
    }
    
    //check fields and validate if data is correct. If everything is correctly entered it returns nil. Else it returns an error message.
    func validateFields() -> String?
    {
        //check that all fields are filled in
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            detailTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            imageURL == ""
        {
            return "Please complete all fields."
        }
        return nil
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        //validate text fields
        let error = validateFields()
        if error != nil
        {
            //show error message for fields
            errorLabel.text = error!
            errorLabel.alpha = 1
        }
        else
        {
            let stackName = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let stackDetail = detailTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let imageUrl = imageURL
            Stack.sharedStack.addStack(name: stackName, desc: stackDetail, imageUrl:imageUrl)
            
            //return segue
            self.performSegue(withIdentifier: "returnFromAddStack", sender: self)
        }
        //reset imageURL
        imageURL = ""
    }
    
    //opens the image picker
    @IBAction func imageChangePressed(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                    self.openCamera()
                }))

                alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                    self.openGallery()
                }))

                alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

                self.present(alert, animated: true, completion: nil)
        /*
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
         */
    }
    
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            else
            {
                let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
    }
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
            else
            {
                let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
    }
    
    //Delegate for picking images
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        //id for image
        let uuid = UUID().uuidString
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        stackImage.image = image
        guard let imageData = image.pngData() else {
            return
        }
        // upload image data
        storage.child("images/\(uuid).png").putData(imageData, metadata: nil) { _, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            
            // get download url
            self.storage.child("images/\(uuid).png").downloadURL { url, error in
                guard let url = url, error == nil else {
                    return
                }
                let urlString = url.absoluteString
                print("Download URL: \(urlString)")
                // save download url to variable
                self.imageURL = urlString
            }
        }
    }
    //Delegate for picking images
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
