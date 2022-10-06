//
//  SupplementTableViewCell.swift
//  SupplementStackApp
//
//  Created by Nick Meyer on 4/15/22.
//

import UIKit

class SupplementTableViewCell: UITableViewCell {

    @IBOutlet weak var supplementImage: UIImageView!
    @IBOutlet weak var supplementName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
