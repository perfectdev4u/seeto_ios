//
//  DeleteSearchVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 07/01/23.
//

import UIKit

protocol DeleteIndexDelegate
{
    func deleteIndex(index : Int)
}
class DeleteSearchVC: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet var backView: UIView!
    @IBOutlet var btnConfirm: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.cornerRadius = 10
        btnConfirm.layer.cornerRadius = 10
        addBlurToView()
        // Do any additional setup after loading the view.
    }
    var index = 0
    var deleteIndexDelegate : DeleteIndexDelegate!
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
    @IBAction func btnConfirmAct(_ sender: Any) {
        deleteIndexDelegate.deleteIndex(index: index)
        self.dismiss(animated: true)

    }
    
    @IBAction func btnCancelAct(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
