//
//  Supplement.swift
//  SupplementStackApp
//
//  Created by Nick Meyer on 3/20/22.
//

import Foundation
import Firebase

class Supplement{
    
    static let shared = Supplement()
    var docRef: DocumentReference!
    private var db = Firestore.firestore()
    
    func addSupplement(stack: String, name:String, dir:String, img:String, ni: [String], na: [String])
    {
        print("add supplement method")
        //save all updated data to the model
        db.collection("Users").document(User.sharedUser.userID).collection("Stacks").document(stack).collection("Supplements").document(name).setData(["supplement_name": name, "supplement_directions": dir, "supplement_image": img, "nutrition_ingredients": ni, "nutrition_amounts": na ], merge: true)
    }
    
    func addNutritionFact(stack: String, ingredient: String, amount: String)
    {
        let facts = [ingredient, amount]
        db.collection("Users").document(User.sharedUser.userID).collection("Stacks").document(stack).collection("Supplements").document(stack).updateData(["nutritionInfo": FieldValue.arrayUnion(facts)])
    }

    
    
}

public struct supplement: Codable{
    let supplementName: String
    let supplementDirections: String?
    let supplementImage: String?
    let nutritionIngredients: [String]
    let nutritionAmounts: [String]
    
    enum CodingKeys: String, CodingKey {
            case supplementName
            case supplementDirections
            case supplementImage
            case nutritionIngredients
            case nutritionAmounts
        
        }
}
