//
//  MapTableViewCell.swift
//  SupplementStackApp
//
//  Created by Nick Meyer on 3/29/22.
//

import UIKit

class MapTableViewCell: UITableViewCell {

    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
