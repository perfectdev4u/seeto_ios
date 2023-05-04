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
        let alert = UIAlertController(title: "Are you sure to exit ?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
          exit(1)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
            print("no")
        }))
        /*If you want work actionsheet on ipad
        then you have to use popoverPresentationController to present the actionsheet,
        otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = self.view.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)

      
    }
    
    @IBAction func btnJustExploring(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InstructionsVC") as! InstructionsVC
        vc.justExploring = true
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
}
