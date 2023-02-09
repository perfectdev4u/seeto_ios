//
//  ProfileViewCell.swift
//  Seeto
//
//  Created by Paramveer Singh on 20/01/23.
//

import UIKit

class ProfileViewCell: UITableViewCell {

    @IBOutlet var btnImageProfilr: UIButton!
    @IBOutlet var imgVideo: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var viewBack: UIView!
    @IBOutlet var viewEdit: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBack.layer.cornerRadius = 10
        viewEdit.layer.cornerRadius = viewEdit.frame.height / 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
