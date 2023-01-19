//
//  InstructionsVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 06/01/23.
//

import UIKit

class InstructionsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnContinueAct(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppCategoryVC") as! AppCategoryVC
        self.navigationController?.pushViewController(vc, animated: true)

    }
    

}
