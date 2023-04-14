//
//  LogoViewCell.swift
//  Seeto
//
//  Created by Paramveer Singh on 13/04/23.
//

import UIKit

class LogoViewCell: UITableViewCell {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var viewEdit: UIView!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var imgMain: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgMain.layer.cornerRadius = imgMain.frame.height / 2
        viewEdit.layer.cornerRadius = viewEdit.frame.height / 2
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
