//
//  NutrientsViewController.swift
//  SupplementStackApp
//
//  Created by Nick Meyer on 4/22/22.
//

import UIKit
import Foundation

class NutrientsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var searchTerm:String?
    
    //var food_results:[SearchResult] = []
    var nutrients_fetch:[Any] = []
    var nutrients_strings:[String] = ["Ingredients"]
    var name_fetch:String = ""
    
    var nut_names:[String] = ["Ingredient"]
    var nut_amounts:[String] = ["Amount"]
    
    var currentStack = ""
    
    @IBOutlet weak var foodNameLabel: UILabel!
    
    @IBOutlet weak var factsTable: UITableView!
    var description2 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    

    
    //return the amount of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // calling the model to get the city count
        return nut_names.count
    }
    //define what goes in each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "factCell", for: indexPath) as! NutrientAPITableViewCell
        cell.layer.borderWidth = 0.25
        cell.factsLabel.text = nut_names[indexPath.row]
        cell.amountsLabel.text = nut_amounts[indexPath.row]
        
        return cell
    }

}


