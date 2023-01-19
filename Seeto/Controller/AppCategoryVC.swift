//
//  AppCategoryVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 06/01/23.
//

import UIKit

class AppCategoryVC: UIViewController {

    @IBOutlet var btnJustExploring: UIButton!
    @IBOutlet var btnFindJob: UIButton!
    @IBOutlet var btnHireTalent: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnFindJob.layer.cornerRadius = 6
        btnHireTalent.layer.cornerRadius = 6
        btnFindJob.layer.borderColor = UIColor.white.cgColor
        btnFindJob.layer.borderWidth = 1
        
        btnJustExploring.layer.cornerRadius = 6
        btnJustExploring.layer.borderColor = UIColor.white.cgColor
        btnJustExploring.layer.borderWidth = 1


    }
    
    @IBAction func btnFindJobAct(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CandidateProfileVC") as! CandidateProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnActBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
