//
//  TextViewCell.swift
//  Seeto
//
//  Created by Paramveer Singh on 06/04/23.
//

import UIKit
import GrowingTextView
class TextViewCell: UITableViewCell , GrowingTextViewDelegate{

    @IBOutlet var heightTextV: NSLayoutConstraint!
    @IBOutlet var textView: GrowingTextView!
    override func awakeFromNib() {
        super.awakeFromNib()
//        heightTextV.constant = 30
        textView.minHeight = 40
        textView.maxLength = 1000
        textView.delegate = self
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        self.heightTextV.constant = height
            self.layoutIfNeeded()
    }
    func adjustUITextViewHeight(arg : UITextView) {
        if let numLines = (arg.contentSize.height / arg.font!.lineHeight) as? CGFloat
        {
            if numLines > 3
            {
//          heightTextV.constant = arg.contentSize.height
            }
           
       }

    }
}
