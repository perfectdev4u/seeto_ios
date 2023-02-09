//
//  AppCategoryVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 06/01/23.
//

import UIKit

class AppCategoryVC: UIViewController {
var appleLogin = false
    @IBOutlet var btnJustExploring: UIButton!
    @IBOutlet var btnFindJob: UIButton!
    @IBOutlet var btnHireTalent: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnFindJob.layer.cornerRadius = 6
        btnHireTalent.layer.cornerRadius = 6
        btnFindJob.layer.borderColor = UIColor.white.cgColor
        btnFindJob.layer.borderWidth = 1
        self.navigationController?.isNavigationBarHidden = true

        btnJustExploring.layer.cornerRadius = 6
        btnJustExploring.layer.borderColor = UIColor.white.cgColor
        btnJustExploring.layer.borderWidth = 1


    }
    
    @IBAction func btnHireTalentAct(_ sender: UIButton) {
//        Toast.show(message:"Under Development", controller: self)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmployerVC") as! EmployerVC
        self.navigationController?.pushViewController(vc, animated: true)

        
        
    }
    @IBAction func btnFindJobAct(_ sender: UIButton) {
        if appleLogin == true
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CandidateProfileVC") as! CandidateProfileVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnActBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnJustExploring(_ sender: UIButton) {
        Toast.show(message:"Under Development", controller: self)

    }
    
}
