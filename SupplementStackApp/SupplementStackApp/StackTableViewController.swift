//
//  StackTableViewController.swift
//  SupplementStackApp
//
//  Created by Nick Meyer on 3/20/22.
//

import UIKit
import Firebase

class StackTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var stackTable: UITableView!
    var stackCount:Int = 0
    var userID:String = ""
    private var db = Firestore.firestore()

    var stacks = [sup_stack]()
    
    var stack_names = [String]()
    var stack_images = [String]()
    var testArray = ["1", "2", "3", "4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.hidesBackButton = true

        //print("User ID: \(userID)")
        //set the user id for use through the whole application
        User.sharedUser.userID = userID
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.checkStack()
            self.loadData()
            
        }
        
    }
    
    func loadData()
    {
        stacks = []
        db.collection("Users").document(User.sharedUser.userID).collection("Stacks").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                
            }
            if let snapshot = snapshot
            {
                snapshot.documents.map { doc in
                    let name = doc["stack_name"] as? String ?? ""
                    let description = doc["stack_description"] as? String ?? ""
                    let img = doc["stack_image"] as? String ?? ""
                    let review = doc["stack_review"] as? String ?? ""
                    let sups = doc["supplements"] as? [supplement] ?? []
                    print("img: \(img)")
                    let tempStack = sup_stack(stackName: name, stackDescription: description, stackImage: img, stackReview: review, supplements: sups)
                    self.stacks.append(tempStack)
                }
                DispatchQueue.main.async {
                    self.stackTable.reloadData()
                }
            }
        }
        print("test",stack_names)
    }
    
    func checkStack()
    {
        for i in stacks{
            print("stack name: \(i.stackName), URL: \(i.stackImage!)")
        }
    }
    
    func convertToURL(imagePath:String) -> URL
    {
        guard let urlString = imagePath as? String,
              let url = URL(string: urlString) else {
            return URL(string: "https://firebasestorage.googleapis.com/v0/b/supplementstacks-36860.appspot.com/o/SM-placeholder-1024x512-1.png?alt=media&token=ff8072c1-f8ae-462d-94f4-2c4ebf0c2456")!
        }
        return url
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stacks.count
    }
    
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stackCell", for: indexPath) as! StackTableViewCell
        cell.layer.borderWidth = 0.25
        
        
        cell.stackName.text = stacks[indexPath.row].stackName
       
        
        let imagePath = stacks[indexPath.row].stackImage
        print("image path: ", imagePath!)
        //convert to url
        if imagePath! != ""
        {
            cell.stackImage.load(url: convertToURL(imagePath: imagePath!))
        }
        
        print("URL for image in tableview cell for row at: \(imagePath!)")

        return cell
    }
    // send the selected stack to the stack view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "stackView"){
            let selectedIndex: IndexPath = self.stackTable.indexPath(for: sender as! UITableViewCell)!
            if let vc: StackViewController = segue.destination as? StackViewController {
                vc.selected_stack = self.stacks[selectedIndex.row]
                }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //used for unwind
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue)
    {
        
    }
}

//for loading images from urls
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
