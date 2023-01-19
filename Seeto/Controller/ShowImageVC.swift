//
//  ShowImageVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 11/01/23.
//

import UIKit

class ShowImageVC: UIViewController {
    var image = UIImage()
    @IBOutlet var imgMain: UIImageView!
    @IBOutlet var backView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imgMain.image = image
        addBlurToView()
        // Do any additional setup after loading the view.
    }
    func addBlurToView() {
        var blurEffect: UIBlurEffect!
        if #available(ios 10.0, *) {
            blurEffect = UIBlurEffect(style: .dark)
        } else {
            blurEffect = UIBlurEffect(style: .light)
        }
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = backView.bounds
        blurredEffectView.alpha = 0.8
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backView.addSubview(blurredEffectView)
    }

    @IBAction func btnBackAct(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
