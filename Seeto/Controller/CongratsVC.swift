//
//  CongratsVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 20/01/23.
//

import UIKit

class CongratsVC: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet var btnThanks: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.cornerRadius = 10
        btnThanks.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnThanksAct(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
