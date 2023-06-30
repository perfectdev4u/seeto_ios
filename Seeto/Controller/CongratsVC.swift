//
//  CongratsVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 20/01/23.
//

import UIKit
protocol CongratsDelegate
{
    func showMatch()
}
class CongratsVC: UIViewController {
    @IBOutlet var mainView: UIView!
    @IBOutlet var btnThanks: UIButton!
    @IBOutlet var lblDescription: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.cornerRadius = 10
        btnThanks.layer.cornerRadius = 10
        if let userType = UserDefaults.standard.value(forKey: "userType") as? Int
        {
            if userType == 1
            {
                lblDescription.text = "You got a Match. Kindly Check your match list."
            }
        }
        // Do any additional setup after loading the view.
    }
    var showMatchDelegate : CongratsDelegate!

    @IBAction func btnThanksAct(_ sender: UIButton) {
        self.dismiss(animated: false)
        self.showMatchDelegate.showMatch()
      
    }
    
}
