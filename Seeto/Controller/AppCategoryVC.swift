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
//        btnFindJob.layer.borderColor = UIColor.white.cgColor
//        btnFindJob.layer.borderWidth = 1
        self.navigationController?.isNavigationBarHidden = true

        btnJustExploring.layer.cornerRadius = 6
//        btnJustExploring.layer.borderColor = UIColor.white.cgColor
//        btnJustExploring.layer.borderWidth = 1
    }
    
    @IBAction func btnHireTalentAct(_ sender: UIButton) {
//        Toast.show(message:"Under Development", controller: self)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InstructionsVC") as! InstructionsVC
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
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InstructionsVC") as! InstructionsVC
            vc.findJob = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnActBack(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
            UserDefaults.standard.removeObject(forKey: "accessToken")
            UserDefaults.standard.removeObject(forKey: "userType")
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
            let window = UIApplication.shared.windows.first
            // Embed loginVC in Navigation Controller and assign the Navigation Controller as windows root
            let nav = UINavigationController(rootViewController: loginVC!)
            window?.rootViewController = nav
        }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
        }))

        present(refreshAlert, animated: true, completion: nil)

      
    }
    
    @IBAction func btnJustExploring(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InstructionsVC") as! InstructionsVC
        vc.justExploring = true
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
}
