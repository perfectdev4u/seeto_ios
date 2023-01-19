//
//  DetailsCell.swift
//  Seeto
//
//  Created by Paramveer Singh on 07/01/23.
//

import UIKit

class DetailsCell: UITableViewCell {

    @IBOutlet var heightCell: NSLayoutConstraint!
    @IBOutlet var heightImage: NSLayoutConstraint!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var widthImage: NSLayoutConstraint!
    @IBOutlet var lblDetails: UILabel!
    @IBOutlet var imgDown: UIImageView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var trailingImg: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
