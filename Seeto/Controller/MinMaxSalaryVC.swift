//
//  MinMaxSalaryVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 06/04/23.
//

import UIKit
protocol MinMaxSalaryDelegate
{
    func addMinMaxSalary(minSal : String,maxSal : String)
}
class MinMaxSalaryVC: UIViewController {
    var jobId = 0
    var minSal = 0
    var maxSal = 0
    @IBOutlet var mainView: UIView!
    @IBOutlet var backView: UIView!
    @IBOutlet var minSalaryTf: UITextField!
    @IBOutlet var maxSalaryTf: UITextField!
    @IBOutlet var btnConfirm: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.cornerRadius = 10
        btnConfirm.layer.cornerRadius = 10
        addBlurToView()
        setUpView()
        if minSal != 0 && maxSal != 0
        {
            minSalaryTf.text = String(describing: minSal)
            maxSalaryTf.text = String(describing: maxSal) 
        }
        // Do any additional setup after loading the view.
    }
     var minMaxSalDelegate : MinMaxSalaryDelegate?
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
    func setUpView()
    {
        let minSalaryString = NSMutableAttributedString(
            string: "Min Salary",
            attributes: [NSAttributedString.Key.foregroundColor: grayColor]
        )
        let maxSalaryString = NSMutableAttributedString(
            string: "Max Salary",
            attributes: [NSAttributedString.Key.foregroundColor: grayColor]
        )
        minSalaryTf.attributedPlaceholder = minSalaryString
        maxSalaryTf.attributedPlaceholder = maxSalaryString
        maxSalaryTf.layer.cornerRadius = 10
        minSalaryTf.layer.cornerRadius = 10
        maxSalaryTf.layer.borderColor = UIColor.white.cgColor
        minSalaryTf.layer.borderColor = UIColor.white.cgColor
        minSalaryTf.layer.borderWidth = 1
        maxSalaryTf.layer.borderWidth = 1

    }
    
    @IBAction func btnConfirmAct(_ sender: Any) {
        if self.minSalaryTf.text!.isEmpty || self.maxSalaryTf.text!.isEmpty
        {
            Toast.show(message: "Please add both Min and Max Salary", controller: self)
            return
        }
        if Int(self.maxSalaryTf.text!)! < Int(self.minSalaryTf.text!)!
        {
            Toast.show(message: "Max Salary should be greater than Min", controller: self)
            return
        }
        minMaxSalDelegate?.addMinMaxSalary(minSal: minSalaryTf.text!, maxSal: maxSalaryTf.text!)
        self.dismiss(animated: true)
    }
    
    

    @IBAction func btnCancelAct(_ sender: Any) {
        self.dismiss(animated: true)
    }


}
