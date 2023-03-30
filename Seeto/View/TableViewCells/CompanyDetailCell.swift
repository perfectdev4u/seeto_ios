//
//  CompanyDetailCell.swift
//  Seeto
//
//  Created by Paramveer Singh on 20/01/23.
//

import UIKit

class CompanyDetailCell: UITableViewCell {

    @IBOutlet var lblPosition: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgLogo: UIImageView!
    @IBOutlet var viewBack: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBack.layer.cornerRadius = 10
        imgLogo.layer.cornerRadius = imgLogo.frame.height / 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
