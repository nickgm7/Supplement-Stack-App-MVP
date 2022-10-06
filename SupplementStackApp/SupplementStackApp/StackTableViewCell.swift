//
//  StackTableViewCell.swift
//  SupplementStackApp
//
//  Created by Nick Meyer on 4/1/22.
//

import UIKit

class StackTableViewCell: UITableViewCell {

    @IBOutlet weak var stackImage: UIImageView!
    @IBOutlet weak var stackName: UILabel!
    @IBOutlet weak var supCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
