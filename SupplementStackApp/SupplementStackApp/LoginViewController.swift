//
//  LoginViewController.swift
//  SupplementStackApp
//
//  Created by Nick Meyer on 3/20/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    var userID:String = ""
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpStyles()
    }
    
    func setUpStyles(){
        
        errorLabel.alpha = 0
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }
    
    //check fields and validate if data is correct. If everything is correctly entered it returns nil. Else it returns an error message.
    func validateFields() -> String?
    {
        
        //check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields!"
        }
        
        //check that password is secure
        let pass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(pass) == false {
            return "Email or password incorrect."
        }
        return nil
    }

    @IBAction func loginPressed(_ sender: Any) {
        
        //for testing
        //set user id
        self.userID = "sH0nbL1s4nOSXz8hmiBH08cD0T02"
        //go to home screen
        self.performSegue(withIdentifier: "goHome", sender: self)
        
        /*
        //validate text fields
        let error = validateFields()
        
        if error != nil {
            //show error message for fields
            errorLabel.text = error!
            errorLabel.alpha = 1
        }
        else{
            //trim text fields
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //sign in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                    //couldnt sign in
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                }
                else{
                    //set user id
                    self.userID = result!.user.uid
                    //go to home screen
                    self.performSegue(withIdentifier: "goHome", sender: self)
                    
                }
            }
        }
        */
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
