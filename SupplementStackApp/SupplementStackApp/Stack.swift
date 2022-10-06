//
//  Stack.swift
//  SupplementStackApp
//
//  Created by Nick Meyer on 3/20/22.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import simd

class Stack {
    
    static let sharedStack = Stack()
    
    private var db = Firestore.firestore()
    
    
    // add new stack to the database
    func addStack(name:String, desc:String, imageUrl:String)
    {
        //save all updated data to the model
        db.collection("Users").document(User.sharedUser.userID).collection("Stacks").document(name).setData(["stack_name": name, "stack_description": desc, "stack_image": imageUrl], merge: true)
    }
    
    // edit a stack on the database
    func editStack(name:String, desc:String, img:String, review:String, sups:[supplement])
    {
        //save all updated data to the model
        db.collection("Users").document(User.sharedUser.userID).collection("Stacks").document(name).setData(["stack_name": name, "stack_description": desc, "stack_image": img, "stack_review": review, "supplements": sups], merge: true)
    }
    
   
    /*
    //get the users stacks and update the stack array
    func getOnce(){
        db.collection("Users").document(User.sharedUser.userID).collection("Stacks").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                }
            }
        }

    }
     */

    
}

public struct sup_stack: Codable{
    let stackName: String
    let stackDescription: String?
    let stackImage: String?
    let stackReview: String?
    let supplements: [supplement]
    
    enum CodingKeys: String, CodingKey {
            case stackName
            case stackDescription
            case stackImage
            case stackReview
            case supplements
        }
}
