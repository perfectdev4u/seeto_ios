//
//  ViewController.swift
//  Seeto
//
//  Created by Paramveer Singh on 04/01/23.
//

import UIKit

class LoginScreenVC: UIViewController {

    @IBOutlet var btnFacebook: UIButton!
    @IBOutlet var btnEmail: UIButton!
    @IBOutlet var btnGmail: UIButton!
    @IBOutlet var btnPhone: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnFacebook.layer.cornerRadius = 15
        btnEmail.layer.cornerRadius = 15
        btnGmail.layer.cornerRadius = 15
        btnPhone.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
    }


}

