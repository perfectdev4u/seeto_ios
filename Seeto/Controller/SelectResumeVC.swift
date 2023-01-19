//
//  SelectResumeVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 20/01/23.
//

import UIKit

class SelectResumeVC: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet var recordSplResume: UIButton!
    
    @IBOutlet var useResumeBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.cornerRadius = 10
        recordSplResume.layer.cornerRadius = 10
        useResumeBtn.layer.cornerRadius = 10
        useResumeBtn.layer.borderColor = blueButtonColor.cgColor
        useResumeBtn.layer.borderWidth = 2
        // Do any additional setup after loading the view.
    }
    
    @IBAction func usePrimaryResume(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
