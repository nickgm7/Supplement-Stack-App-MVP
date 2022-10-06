//
//  User.swift
//  SupplementStackApp
//
//  Created by Nick Meyer on 3/20/22.
//

import Foundation
import Firebase
import FirebaseFirestore

class User{
    
    static let sharedUser = User()
    
    
    
    
    var userID:String = ""
    
    var docRef: DocumentReference!
    
    init()
    {
        docRef = Firestore.firestore().document("Users/nickm4")
    }
    
    func checkUser(username:String)
    {
        
    }
    
    func addUser(username:String)
    {
        //add user to the database here
        let dataToSave: [String:Any] = ["username": username, "stack" : []]
        docRef.updateData(dataToSave)
    }
    

    
    
    
}

public struct user: Codable{
    let userID: String
    let firstName: String
    let lastName: String
    let email: String
    let stacks: [sup_stack]?
    
    enum CodingKeys: String, CodingKey {
        case userID
        case firstName
        case lastName
        case email
        case stacks
    }
}
