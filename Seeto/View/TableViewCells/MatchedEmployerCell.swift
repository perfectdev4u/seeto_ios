//
//  MatchedEmployerCell.swift
//  Seeto
//
//  Created by Paramveer Singh on 08/01/23.
//

import UIKit

class MatchedEmployerCell: UITableViewCell {

    @IBOutlet var companyTitle: UILabel!
    @IBOutlet var noOfEmployeesLbl: UILabel!
    @IBOutlet var seperatorView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
