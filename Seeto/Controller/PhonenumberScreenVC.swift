//
//  PhonenumberScreenVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 05/01/23.
//

import UIKit

class PhonenumberScreenVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var lblLeading: NSLayoutConstraint!
    @IBOutlet weak var lblPhoneNum: UILabel!
    
    @IBOutlet weak var underLineViewLeading: NSLayoutConstraint!
    @IBOutlet weak var btnPicker: UIButton!
    @IBOutlet weak var viewUnderline: UIView!
    var index = 0
    var myPickerView : UIPickerView!
    var email = false
    @IBOutlet var tfCountryCode: UITextField!
    @IBOutlet var tfPhone: UITextField!
    @IBOutlet var btnPhone: UIButton!
    var pickerView : UIPickerView!
    var mobileCode = ["USA","UKR"]
    override func viewDidLoad() {
        super.viewDidLoad()
        btnPhone.layer.cornerRadius = 15
        tfPhone.attributedPlaceholder = NSAttributedString(
            string: "Enter your mobile number",
            attributes: [NSAttributedString.Key.foregroundColor: grayColor]
        )
        self.navigationController?.isNavigationBarHidden = true
        PickerView()
        if email == true
        {
            setUpEmailView()
        }
        // Do any additional setup after loading the view.
    }
    
    func setUpEmailView()
    {
        lblLeading.constant = 25
        underLineViewLeading.constant = 20
        lblPhoneNum.text = "What's your email Id?"
        btnPicker.isHidden = true
        viewUnderline.isHidden = true
        tfCountryCode.isHidden = true
        tfPhone.attributedPlaceholder = NSAttributedString(
            string: "Enter your email Id",
            attributes: [NSAttributedString.Key.foregroundColor: grayColor]
        )
        tfPhone.keyboardType = .emailAddress
        tfPhone.textContentType = .emailAddress

    }
    
    func PickerView(){
       // UIPickerView
       self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
       self.myPickerView.delegate = self
       self.myPickerView.dataSource = self
       self.myPickerView.backgroundColor = UIColor.white
       tfCountryCode.inputView = self.myPickerView

       // ToolBar
       let toolBar = UIToolbar()
       toolBar.barStyle = .default
       toolBar.isTranslucent = true
       toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
       toolBar.sizeToFit()

       // Adding Button ToolBar
       let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(PhonenumberScreenVC.doneClick))
        doneButton.tintColor = UIColor.black
       let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
       let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(PhonenumberScreenVC.cancelClick))
        cancelButton.tintColor = UIColor.black

       toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
       toolBar.isUserInteractionEnabled = true
       tfCountryCode.inputAccessoryView = toolBar
       tfCountryCode.delegate = self
    }
    @objc func doneClick() {
        tfCountryCode.text = mobileCode[index] + " ▼"
        tfCountryCode.resignFirstResponder()
     }
    @objc func cancelClick() {
        tfCountryCode.resignFirstResponder()
    }

    @IBAction func btnNextAct(_ sender: UIButton) {
        if tfPhone.text == ""
        {
            Toast.show(message: email == true ? "Enter Email Id" : "Enter Phone Number", controller: self)

        }
        else
        {
            callLoginApi()
        }
    }
    
    func callLoginApi()
    {
        let phoneNumber =  (tfCountryCode.text == "USA" + " ▼" ? "1" : "380") + tfPhone.text!
        var params = ["grantType" : "phone_number" ,"phoneNumber" :  tfPhone.text!] as [String : Any]
        if email == true
        {
            
            params = ["email" :  tfPhone.text!] as [String : Any]
        }
        
        ApiManager().postRequest(parameters: params,api: email == true ? ApiManager.shared.LoginEmailApi : ApiManager.shared.LoginPhoneApi) { dataJson, error in
            if let error = error
            {
                DispatchQueue.main.async {
                    self.showToast(message: error.localizedDescription)
                }
            }
            else
            {
            if let dataJson = dataJson
                {
              if String(describing: (dataJson["statusCode"] as AnyObject)) == "200"
                {
                  DispatchQueue.main.async {
                      let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                      vc.phoneNumber = self.tfPhone.text!
                      vc.email = self.email
                      self.navigationController?.pushViewController(vc, animated: true)

                    //  self.showToast(message: ()
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
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnActCountryCode(_ sender: UIButton) {
        PickerView()
    }
}

extension PhonenumberScreenVC : UITextFieldDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mobileCode.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mobileCode[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        index = row
    }

}

