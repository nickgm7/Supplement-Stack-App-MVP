//
//  SignUpViewController.swift
//  SupplementStackApp
//
//  Created by Nick Meyer on 4/18/22.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    var userID:String = ""
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpStyles()
    }
    
    func setUpStyles()
    {
        
        errorLabel.alpha = 0
        
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }

    //check fields and validate if data is correct. If everything is correctly entered it returns nil. Else it returns an error message.
    func validateFields() -> String?
    {
        
        //check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields!"
        }
        
        //check that password is secure
        let pass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(pass) == false {
            return "Please make sure your password is at least 8 characters and contains a special character and number."
        }
        
        
        return nil
    }
    
    
    @IBAction func signUpPressed(_ sender: Any)
    {
        
        //validate fields
        let error = validateFields()
        
        if error != nil {
            //show error message for fields
            errorLabel.text = error!
            errorLabel.alpha = 1
        }
        else{
            //trim the data to make it clean
            let firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //create the user
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                
                //check for errors
                if let error = error
                {
                    //there is an error with user creation
                    self.errorLabel.text = "Error creating user: \(error)"
                    self.errorLabel.alpha = 1
                }
                else
                {
                    //user was created successfully
                    
                    let db = Firestore.firestore()
                    db.collection("Users").document(result!.user.uid).setData(["firstname":firstname, "lastname":lastname, "uid":result!.user.uid])
                    { (error) in
                        if error != nil
                        {
                            // show error message
                            //there is an error with user creation
                            self.errorLabel.text = "User created but user data not saved."
                            self.errorLabel.alpha = 1
                        }
                    }
                    //set user id
                    self.userID = result!.user.uid
                    //go to home screen
                    self.performSegue(withIdentifier: "goHome", sender: self)
                }
            }
        }
    }
    

    //sends the userID to the home page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goHome"
        {
            if let StackTable = segue.destination as? StackTableViewController {
                StackTable.userID = self.userID
            }
        }
    }

}
