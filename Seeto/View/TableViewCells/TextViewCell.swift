//
//  TextViewCell.swift
//  Seeto
//
//  Created by Paramveer Singh on 06/04/23.
//

import UIKit

class TextViewCell: UITableViewCell {

    @IBOutlet var heightTextV: NSLayoutConstraint!
    @IBOutlet var textView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        heightTextV.constant = 30
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func adjustUITextViewHeight(arg : UITextView) {
        if let numLines = (arg.contentSize.height / arg.font!.lineHeight) as? CGFloat
        {
            if numLines > 3
            {
          heightTextV.constant = arg.contentSize.height
            }
           
       }

    }
}
