//
//  SupplementViewController.swift
//  SupplementStackApp
//
//  Created by Nick Meyer on 3/20/22.
//

import UIKit
import Firebase
class SupplementViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var supImage: UIImageView!
    @IBOutlet weak var supName: UILabel!
    @IBOutlet weak var supDirections: UITextView!
    @IBOutlet weak var supFactsTable: UITableView!
    
    var selected_stack_name:String = ""
    var selected_sup:supplement = supplement(supplementName: "holder", supplementDirections: "holder", supplementImage: "holder", nutritionIngredients: [], nutritionAmounts: [])
    
    private var db = Firestore.firestore()

    var ingredients:[String] = []
    var amounts:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        supName.text = selected_sup.supplementName
        supDirections.text = selected_sup.supplementDirections
        supImage.load(url: convertToURL(imagePath: selected_sup.supplementImage!))
        print("directions: ", selected_sup.supplementDirections)
        // Do any additional setup after loading the view.
        self.loadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.loadData()
        }
        
    }

    func loadData()
    {
        ingredients = []
        amounts = []
        db.collection("Users").document(User.sharedUser.userID).collection("Stacks").document(selected_stack_name).collection("Supplements").document(selected_sup.supplementName).getDocument { (document, err) in
            if let document = document, document.exists {
                    let nutritionIngredients = document["nutrition_ingredients"] as? [String] ?? ["no facts"]
                    let nutritionAmounts = document["nutrition_amounts"] as? [String] ?? ["no facts"]
                    self.ingredients = nutritionIngredients
                    self.amounts = nutritionAmounts
                    print("Document data: \(nutritionIngredients)")
                    self.supFactsTable.reloadData()
                } else {
                    print("Document does not exist")
                }
                
            }
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nutCell", for: indexPath) as! NutritionTableViewCell
        cell.layer.borderWidth = 0.25
        cell.ingredient.text = ingredients[indexPath.row]
        cell.amount.text = amounts[indexPath.row]
        return cell
    }
    
    func convertToURL(imagePath:String) -> URL
    {
        guard let urlString = imagePath as? String,
              let url = URL(string: urlString) else {
            return URL(string: "https://firebasestorage.googleapis.com/v0/b/supplementstacks-36860.appspot.com/o/SM-placeholder-1024x512-1.png?alt=media&token=ff8072c1-f8ae-462d-94f4-2c4ebf0c2456")!
        }
        return url
    }
    
}
