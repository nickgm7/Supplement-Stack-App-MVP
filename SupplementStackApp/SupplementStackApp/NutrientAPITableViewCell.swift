//
//  NutrientAPITableViewCell.swift
//  SupplementStackApp
//
//  Created by Nick Meyer on 4/22/22.
//

import UIKit

class NutrientAPITableViewCell: UITableViewCell {

    @IBOutlet weak var factsLabel: UILabel!
    @IBOutlet weak var amountsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
