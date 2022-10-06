//
//  SupplementEditorViewController.swift
//  SupplementStackApp
//
//  Created by Nick Meyer on 3/20/22.
//
// FoodData Central API key: mRqWpT6OSpj4mk9Pmt6HzfZjUheNSkLu8UIWOTeN

import UIKit
import Firebase
import FirebaseStorage
import Foundation

class SupplementEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var supImage: UIImageView!
    @IBOutlet weak var supName: UITextField!
    @IBOutlet weak var supDirections: UITextView!
    @IBOutlet weak var nutritionTable: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var current_stack = ""
    
    var nut_names:[String] = ["Ingredient"]
    var nut_amounts:[String] = ["Amount"]
    private let storage = Storage.storage().reference()
    var imageURL:String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpStyles()
        print("Current stack -> ",current_stack)
        
    }
    func setUpStyles()
    {
        errorLabel.alpha = 0
        errorLabel.textColor = UIColor.red
    }
    func validateFields() -> String?
    {
        //check that all fields are filled in
        if supName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            supDirections.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            imageURL == ""
        {
            return "Please complete all fields."
        }
        return nil
    }
    
    
    
    
    
    
    @IBAction func savePressed(_ sender: Any) {
        
        //validate text fields
        print("in save pressed")
        let error = validateFields()
        if error != nil
        {
            print("in error")
            //show error message for fields
            errorLabel.text = error!
            errorLabel.alpha = 1
        }
        else
        {
            print("in save else")
            let name = supName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let directions = supDirections.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let imageUrl = imageURL
            print(current_stack, "here")
            Supplement.shared.addSupplement(stack: current_stack, name: name, dir: directions, img: imageUrl, ni: nut_names, na: nut_amounts)
            errorLabel.text = "\(name) Saved!"
            errorLabel.alpha = 1
            errorLabel.textColor = UIColor.green
            //return segue
            //self.performSegue(withIdentifier: "returnFromSupEdit", sender: self)
        }
        //reset imageURL
        imageURL = ""
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        
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
    
    
    @IBAction func addNutritionInfo(_ sender: Any)
    {
        
        let alertController = UIAlertController(title: "Add Nutrition Info", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (aciton) in
            
            let ingredient = alertController.textFields?.first?.text
            let amount = alertController.textFields?.last?.text

            if ingredient != "" && amount != "" && ingredient != amount{
                //Supplement.shared.addNutritionFact(stack: self.current_stack, ingredient: ingredient!, amount: amount!)
                self.nut_names.append(ingredient!)
                self.nut_amounts.append(amount!)
                self.nutritionTable.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Fish Oil"})
        
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "100 mg"})
        
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func checkNuts(_ sender: Any) {
        foodSearch(searchTerm: supName.text)
    }
    func foodSearch(searchTerm: String?)
    {
        nut_names = ["Ingredient"]
        nut_amounts = ["Amount"]
        if searchTerm != nil
        {
            let noSpaceString = searchTerm?.replacingOccurrences(of: " ", with: "%20")
            let urlAsString = "https://api.nal.usda.gov/fdc/v1/foods/search?api_key=mRqWpT6OSpj4mk9Pmt6HzfZjUheNSkLu8UIWOTeN&query=" + noSpaceString!
            print(urlAsString)
            
            let url = URL(string: urlAsString)!
            
            let urlSession = URLSession.shared
            
            
            
            let jsonQuery = urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
                if (error != nil) {
                    print(error!.localizedDescription)
                }
                var err: NSError?
                
                let jsonResult = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                if err != nil
                {
                    print("Json error: \(err!.localizedDescription)")
                }
                //print(jsonResult)
                
                if (err != nil) {
                    print("JSON Error \(err!.localizedDescription)")
                }
                 let food_json:NSArray = jsonResult["foods"] as! NSArray
                 for i in food_json
                 {
                     
                     let y = i as? [String: AnyObject]
                     let description: String = (y!["description"] as? String)! as String
                     print("=========================")
                     print("Food: ", description)
                     print("=========================")
                     let foodNuts:NSArray = (y!["foodNutrients"] as? NSArray)! as NSArray
                     for j in foodNuts
                     {
                         print(j)
                         let z = j as? [String: AnyObject]
                         let nut: String = (z!["nutrientName"] as? String)! as String
                         let amt: Double = (z!["value"] as? Double)! as Double
                         let unit: String = (z!["unitName"] as? String)! as String
                         print(nut)
                         //Supplement.shared.addNutritionFact(stack: self.currentStack, ingredient: nut, amount: String(amt) + unit)
                         self.nut_names.append(nut)
                         self.nut_amounts.append(String(amt) + unit)
                     }
                     break
                 }
                DispatchQueue.main.async {
                    self.nutritionTable.reloadData()
                }
                
            })
            
            
            jsonQuery.resume()
        }
        
    }
    
    //return the amount of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // calling the model to get the city count
        return nut_names.count
    }
    //define what goes in each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nutritionCell", for: indexPath) as! NutritionTableViewCell
        cell.layer.borderWidth = 0.25
        cell.ingredient.text = nut_names[indexPath.row]
        cell.amount.text = nut_amounts[indexPath.row]
        return cell
    }
    
    //Delegate for picking images
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        //id for image
        let uuid = UUID().uuidString
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
            return
        }
        supImage.image = image
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


