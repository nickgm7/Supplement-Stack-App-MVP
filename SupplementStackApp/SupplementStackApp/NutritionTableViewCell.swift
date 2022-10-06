//
//  NutritionTableViewCell.swift
//  SupplementStackApp
//
//  Created by Nick Meyer on 4/15/22.
//

import UIKit

class NutritionTableViewCell: UITableViewCell {

    @IBOutlet weak var ingredient: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
