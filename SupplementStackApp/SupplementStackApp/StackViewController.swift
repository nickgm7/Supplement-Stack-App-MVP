//
//  StackViewController.swift
//  SupplementStackApp
//
//  Created by Nick Meyer on 3/20/22.
//

import UIKit
import Firebase

class StackViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var stackImageView: UIImageView!
    @IBOutlet weak var stackNameLabel: UILabel!
    @IBOutlet weak var stackDetailsTextView: UITextView!
    @IBOutlet weak var supplementsTableView: UITableView!
    @IBOutlet weak var stackReviewTextView: UITextView!
    

    var selected_stack:sup_stack = sup_stack(stackName: "holder", stackDescription: "holder", stackImage: "holder", stackReview: "holder", supplements: [])
    
    private var db = Firestore.firestore()

    var sups = [supplement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackNameLabel.text = selected_stack.stackName
        stackDetailsTextView.text = selected_stack.stackDescription
        stackReviewTextView.text = selected_stack.stackReview
        stackImageView.load(url: convertToURL(imagePath: selected_stack.stackImage!))
        // Do any additional setup after loading the view.
        self.loadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.loadData()
            
        }
        
    }
    /*
     let supplementName: String
     let supplementDirections: String?
     let supplementImage: String?
     let amtPerDay: Int?
     let withFood: Bool?
     let nutritionInfo: [String]
     */
    
    func loadData()
    {
        sups = []
        db.collection("Users").document(User.sharedUser.userID).collection("Stacks").document(selected_stack.stackName).collection("Supplements").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                
            }
            if let snapshot = snapshot
            {
                snapshot.documents.map { doc in
                    let name = doc["supplement_name"] as? String ?? ""
                    let directions = doc["supplement_directions"] as? String ?? ""
                    let img = doc["supplement_image"] as? String ?? ""
                    let nutritionIngredients = doc["nutrition_ingredients"] as? [String] ?? ["no facts"]
                    let nutritionAmounts = doc["nutrition_amounts"] as? [String] ?? ["no facts"]
                    let tempStack = supplement(supplementName: name, supplementDirections: directions, supplementImage: img, nutritionIngredients: nutritionIngredients, nutritionAmounts: nutritionAmounts)
                    self.sups.append(tempStack)
                }
                self.supplementsTableView.reloadData()
            }
        }
    }

    @IBAction func savePressed(_ sender: Any) {
        // if details or description are changed update them
        if (stackDetailsTextView.text != selected_stack.stackDescription || stackReviewTextView.text != selected_stack.stackReview)
        {
            Stack.sharedStack.editStack(name: selected_stack.stackName, desc: stackDetailsTextView.text!, img: selected_stack.stackImage!, review: stackReviewTextView.text!, sups: selected_stack.supplements)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sups.count
    }
    
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "supplementCell", for: indexPath) as! SupplementTableViewCell
        cell.layer.borderWidth = 0.25
        cell.supplementName.text = sups[indexPath.row].supplementName
        
        let imagePath = sups[indexPath.row].supplementImage
        print("image path in stack table: ", imagePath!)
        //convert to url
        if imagePath != ""
        {
            cell.supplementImage.load(url: convertToURL(imagePath: imagePath!))
        }
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
    // send the selected stack to the stack view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "addSup"){
           
            if let vc: SupplementEditorViewController = segue.destination as? SupplementEditorViewController {
                vc.current_stack = selected_stack.stackName
                }
        }
        if(segue.identifier == "viewSup"){
           
            if let vc: SupplementViewController = segue.destination as? SupplementViewController {
                vc.selected_stack_name = selected_stack.stackName
                let selectedIndex: IndexPath = self.supplementsTableView.indexPath(for: sender as! UITableViewCell)!
                if let vc: SupplementViewController = segue.destination as? SupplementViewController {
                    vc.selected_sup = self.sups[selectedIndex.row]
                    }
                
            }
        }
        
    }
    
    //used for unwind
    @IBAction func stackView(unwindSegue: UIStoryboardSegue)
    {
        
    }
}


