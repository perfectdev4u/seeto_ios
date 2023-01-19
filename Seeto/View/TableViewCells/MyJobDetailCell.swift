//
//  MyJobDetailCell.swift
//  Seeto
//
//  Created by Paramveer Singh on 07/01/23.
//

import UIKit

class MyJobDetailCell: UITableViewCell {
    @IBOutlet var myJobTitleLbl: UILabel!
    @IBOutlet var myJobDataLbl: UILabel!
    
    @IBOutlet var trailingMainView: NSLayoutConstraint!
    @IBOutlet var leadingMainView: NSLayoutConstraint!
    @IBOutlet var mainView: UIView!
    @IBOutlet var seperaterView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
