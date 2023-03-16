//
//  MyJobSearchesCell.swift
//  Seeto
//
//  Created by Paramveer Singh on 07/01/23.
//

import UIKit

class MyJobSearchesCell: UITableViewCell {
    @IBOutlet var seperatorView: UIView!
    
    @IBOutlet var btnLike: UIButton!
    @IBOutlet var imgMain: UIImageView!
    @IBOutlet var viewPlay: UIView!
    @IBOutlet var widthPic: NSLayoutConstraint!
    @IBOutlet var heightPic: NSLayoutConstraint!
    @IBOutlet var lblLikes: UILabel!
    @IBOutlet var lblDesignation: UILabel!
    @IBOutlet var btnPlayVideo: UIButton!
    @IBOutlet var lblSkillLevel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewPlay.layer.cornerRadius = viewPlay.frame.height / 2
        imgMain.layer.cornerRadius = imgMain.frame.height / 2

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
