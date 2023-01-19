//
//  CandidateProfileCell.swift
//  Seeto
//
//  Created by Paramveer Singh on 06/01/23.
//

import UIKit

class CandidateProfileCell: UITableViewCell {

    @IBOutlet var phoneCountryView: UIView!
    @IBOutlet var topImage: NSLayoutConstraint!
    @IBOutlet var flagPicView: UIImageView!
    @IBOutlet var heightImg: NSLayoutConstraint!
    @IBOutlet var btnSelectCountryView: UIButton!
    @IBOutlet var leadingTf: NSLayoutConstraint!
    @IBOutlet var widthImg: NSLayoutConstraint!
    @IBOutlet var imgVector: UIImageView!
    @IBOutlet var tfMain: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        tfMain.attributedPlaceholder = NSAttributedString(
            string: "Enter data",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
