//
//  MatchedEmployerCell.swift
//  Seeto
//
//  Created by Paramveer Singh on 08/01/23.
//

import UIKit

class MatchedEmployerCell: UITableViewCell {

    @IBOutlet var companyTitle: UILabel!
    @IBOutlet var imgThumb: UIImageView!
    @IBOutlet var noOfEmployeesLbl: UILabel!
    @IBOutlet var seperatorView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgThumb.layer.cornerRadius = imgThumb.frame.height / 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
