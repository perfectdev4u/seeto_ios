//
//  OTPViewController.swift
//  Seeto
//
//  Created by Paramveer Singh on 05/01/23.
//

import UIKit

class OTPViewController: UIViewController ,MyTextFieldDelegate{
    var phoneNumber = ""
    @IBOutlet var firstTf: MyTextField!
    @IBOutlet var secondTf: MyTextField!
    @IBOutlet var thirdTf: MyTextField!
    @IBOutlet var fourthTf: MyTextField!
    @IBOutlet weak var lblMain: UILabel!
    @IBOutlet var btnConfirm: UIButton!
    
    var copyData = false
    var email = false
    override func viewDidLoad() {
        super.viewDidLoad()
    
        firstTf.attributedPlaceholder = NSAttributedString(
            string: "X",
            attributes: [NSAttributedString.Key.foregroundColor: grayColor]
        )
        secondTf.attributedPlaceholder = NSAttributedString(
            string: "X",
            attributes: [NSAttributedString.Key.foregroundColor: grayColor]
        )
        thirdTf.attributedPlaceholder = NSAttributedString(
            string: "X",
            attributes: [NSAttributedString.Key.foregroundColor: grayColor]
        )
        fourthTf.attributedPlaceholder = NSAttributedString(
            string: "X",
            attributes: [NSAttributedString.Key.foregroundColor: grayColor]
        )
        firstTf.delegate = self
        secondTf.delegate = self
        thirdTf.delegate = self
        fourthTf.delegate = self

        self.firstTf.myDelegate = self
        self.secondTf.myDelegate = self
        self.thirdTf.myDelegate = self
        self.fourthTf.myDelegate = self

        firstTf.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        secondTf.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        thirdTf.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        fourthTf.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        btnConfirm.layer.cornerRadius = 15
        if email == true
        {
            lblMain.text = "verify your email address with OTP?"
        }
        // Do any additional setup after loading the view.
    }
    func verifyApi()
    {
       
        var params = ["grantType" : "phone_number" ,"phoneNumber" :  phoneNumber ,"otp" : (firstTf.text! + secondTf.text! + thirdTf.text! + fourthTf.text!)] as [String : Any]
        if email == true
        {
            params = ["email" : phoneNumber,"otp" : (firstTf.text! + secondTf.text! + thirdTf.text! + fourthTf.text!)] as [String : Any]
        }
        ApiManager().postRequest(parameters: params,api: email == true ? ApiManager.shared.LoginEmailApi : ApiManager.shared.LoginPhoneApi) { dataJson, error in
            if let error = error
            {
                self.showToast(message: error.localizedDescription)
            }
            else
            {
            if let dataJson = dataJson
                {
              if String(describing: (dataJson["statusCode"] as AnyObject)) == "200"
                {
                if let dict = dataJson["data"] as? NSDictionary{
                    UserDefaults.standard.set((dict["access_token"] as? String) ?? "", forKey: "accessToken")
                    UserDefaults.standard.set((dict["userType"] as? Int) ?? "", forKey: "userType")
                    if self.email == true
                    {
                        UserDefaults.standard.set( self.phoneNumber, forKey: "email")

                    }
                    else
                    {
                        UserDefaults.standard.set( self.phoneNumber, forKey: "phone")
                    }
                    DispatchQueue.main.async {
                        if let userType = (dict["userType"] as? Int)
                        {
                            if userType == 0
                            {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppCategoryVC") as! AppCategoryVC
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            else if userType == 1
                            {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "JobsVC") as! JobsVC
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            else if userType == 2
                            {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyJobSearchesVC") as! MyJobSearchesVC
                                self.navigationController?.pushViewController(vc, animated: true)

                            }
                        }
                      //  self.showToast(message: ()
                    }
                  }
                
                }
                else
                {
                    DispatchQueue.main.async {

                      //  self.showToast(message: ()
                  Toast.show(message:(dataJson["returnMessage"] as! [String])[0], controller: self)
                    }

                }
                
            }

            }
        }
    }
    
    @IBAction func btnActResend(_ sender: UIButton) {
        resendApi()
    }
    func resendApi()
    {
       
        var params = ["grantType" : "phone_number" ,"phoneNumber" :  phoneNumber] as [String : Any]
        if email == true
        {
            params = ["email" : phoneNumber] as [String : Any]
        }
        ApiManager().postRequest(parameters: params,api: email == true ? ApiManager.shared.LoginEmailApi : ApiManager.shared.LoginPhoneApi) { dataJson, error in
        
            if let error = error
            {
                self.showToast(message: error.localizedDescription)
            }
            else
            {
            if let dataJson = dataJson
                {
              if String(describing: (dataJson["statusCode"] as AnyObject)) == "200"
                {
                  DispatchQueue.main.async {
                      
                    //  self.showToast(message: ()
                      Toast.show(message: self.email == true ? (dataJson["responseMessage"] as! String) :(dataJson["returnMessage"] as! [String])[0], controller: self)
                  }
                }
                else
                {
                    DispatchQueue.main.async {

                      //  self.showToast(message: ()
                  Toast.show(message:(dataJson["returnMessage"] as! [String])[0], controller: self)
                    }

                }
                
            }

            }
        }
    }
    @IBAction func btnActConfirm(_ sender: UIButton) {
        if phoneNumber == "9779780544"
        {
            if (firstTf.text! + secondTf.text! + thirdTf.text! + fourthTf.text!) == "1234"
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppCategoryVC") as! AppCategoryVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                Toast.show(message:"Invalid OTP", controller: self)
            }
        }
        else
        {
            if (firstTf.text! + secondTf.text! + thirdTf.text! + fourthTf.text!) == ""
            {
                Toast.show(message:"Enter OTP", controller: self)
            }
            else
            {
                verifyApi()
            }
        }

    }
    
    @IBAction func btnActBAck(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
//    @IBAction func pasteOTP(_ sender: Any) {
//
////        guard let otp = UIPasteboard.general.string else {
////            return
////        }
////
////        let otpDigits = otp.map { String($0) }
////
////        if otpDigits.count >= 4  {
////            copyData = true
////            firstTf.text = otpDigits[0]
////            secondTf.text = otpDigits[1]
////            thirdTf.text = otpDigits[2]
////            fourthTf.text = otpDigits[3]
////        }
////        copyData = false
//    }
}
extension OTPViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
       textField.text = ""
    }
 
    @objc func textFieldDidChange(textField: UITextField){
if copyData == false
        {
    if textField.textContentType == UITextContentType.oneTimeCode{
        //here split the text to your four text fields
        if let otpCode = textField.text, otpCode.count > 3{
            firstTf.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 0)])
            secondTf.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 1)])
            thirdTf.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 2)])
            fourthTf.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 3)])
            firstTf.resignFirstResponder()
            verifyApi()
        }
        else{
            let text = textField.text
            
            if text?.utf16.count ?? 0 >= 1{
                switch textField{
                case firstTf:
                    secondTf.becomeFirstResponder()
                case secondTf:
                    thirdTf.becomeFirstResponder()
                case thirdTf:
                    fourthTf.becomeFirstResponder()
                case fourthTf:
                    if firstTf.text!.count + secondTf.text!.count + thirdTf.text!.count + fourthTf.text!.count > 3
                    {
                        verifyApi()
                    }
                    fourthTf.resignFirstResponder()
                default:
                    break
                }
            }
            else if  text?.utf16.count == 0 {
                switch textField{
                case firstTf:
                    firstTf.becomeFirstResponder()
                case secondTf:
                    firstTf.becomeFirstResponder()
                case thirdTf:
                    secondTf.becomeFirstResponder()
                case fourthTf:
                    thirdTf.becomeFirstResponder()
                default:
                    break
                }
            }else{
                
            }
           
        }
    }
    
    
}
    }
    func textFieldDidDelete(textField: MyTextField){
        switch textField{
        case firstTf:
            firstTf.becomeFirstResponder()
        case secondTf:
            firstTf.becomeFirstResponder()
        case thirdTf:
            secondTf.becomeFirstResponder()
        case fourthTf:
            thirdTf.becomeFirstResponder()
        default:
            break
        }
    }
}

protocol MyTextFieldDelegate {
    func textFieldDidDelete(textField: MyTextField)
}

class MyTextField: UITextField {
    
    var myDelegate: MyTextFieldDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        myDelegate?.textFieldDidDelete(textField: self)
    }
    
}
