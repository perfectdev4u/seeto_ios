//
//  MyJobSearchesCell.swift
//  Seeto
//
//  Created by Paramveer Singh on 07/01/23.
//

import UIKit

class MyJobSearchesCell: UITableViewCell {
    @IBOutlet var seperatorView: UIView!
    
    @IBOutlet var lblLikes: UILabel!
    @IBOutlet var lblDesignation: UILabel!
    @IBOutlet var lblSkillLevel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
