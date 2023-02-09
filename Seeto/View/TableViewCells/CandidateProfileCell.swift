//
//  CandidateProfileCell.swift
//  Seeto
//
//  Created by Paramveer Singh on 06/01/23.
//

import UIKit
import SkyFloatingLabelTextField
class CandidateProfileCell: UITableViewCell {

    @IBOutlet var colllV: UICollectionView!
    @IBOutlet var phoneCountryView: UIView!
    @IBOutlet var topImage: NSLayoutConstraint!
    @IBOutlet var flagPicView: UIImageView!
    @IBOutlet var heightCollV: NSLayoutConstraint!
    @IBOutlet var heightImg: NSLayoutConstraint!
    @IBOutlet var btnSelectCountryView: UIButton!
    @IBOutlet var leadingTf: NSLayoutConstraint!
    @IBOutlet var widthImg: NSLayoutConstraint!
    @IBOutlet var imgVector: UIImageView!
    @IBOutlet var tfMain: SkyFloatingLabelTextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        tfMain.attributedPlaceholder = NSAttributedString(
            string: "Enter data",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        tfMain.textColor = .white
        tfMain.lineColor = .clear
        tfMain.selectedTitleColor = grayColor
        tfMain.titleColor = grayColor
        tfMain.titleFormatter = { $0 }        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
