//
//  StartViewController.swift
//  SupplementStackApp
//
//  Created by Nick Meyer on 4/18/22.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpStyles()
    }
    

    func setUpStyles(){
        
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
        
    }

}
