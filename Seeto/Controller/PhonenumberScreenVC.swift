//
//  PhonenumberScreenVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 05/01/23.
//

import UIKit
import CountryPickerView

class PhonenumberScreenVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CountryPickerViewDelegate, CountryPickerViewDataSource{
   
    @IBOutlet weak var lblLeading: NSLayoutConstraint!
    @IBOutlet weak var lblPhoneNum: UILabel!
    @IBOutlet var lblCode: UILabel!
    @IBOutlet var imgFlag: UIImageView!
    
    @IBOutlet weak var underLineViewLeading: NSLayoutConstraint!
    @IBOutlet weak var btnPicker: UIButton!
    @IBOutlet weak var viewUnderline: UIView!
    var index = 0
    var email = false
    @IBOutlet var tfCountryCode: UITextField!
    @IBOutlet var tfPhone: UITextField!
    @IBOutlet var btnPhone: UIButton!
    var pickerView : UIPickerView!
    var mobileCode = ["USA","UKR"]
     var myPickerView: CountryPickerView!

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
        tfPhone.delegate = self
        // Do any additional setup after loading the view.
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func setUpEmailView()
    {
        lblCode.isHidden = true
        imgFlag.isHidden = true
        lblLeading.constant = 25
        underLineViewLeading.constant = 20
        lblPhoneNum.text = "What's your email address?"
        btnPicker.isHidden = true
        viewUnderline.isHidden = true
        tfCountryCode.isHidden = true
        tfPhone.attributedPlaceholder = NSAttributedString(
            string: "Enter your email address",
            attributes: [NSAttributedString.Key.foregroundColor: grayColor]
        )
        tfPhone.keyboardType = .emailAddress
        tfPhone.textContentType = .emailAddress

    }
    
    func PickerView(){
       // UIPickerView
       self.myPickerView = CountryPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
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
        tfCountryCode.text = myPickerView.selectedCountry.name + " ▼"
        tfCountryCode.resignFirstResponder()
     }
    @objc func cancelClick() {
        tfCountryCode.resignFirstResponder()
    }

    @IBAction func btnNextAct(_ sender: UIButton) {
        if tfPhone.text == ""
        {
            Toast.show(message: email == true ? "Enter email address" : "Enter Phone Number", controller: self)
            return

        }
        else
        {
            if email == true
            {
               if isValidEmail(tfPhone.text!) == true
                {
                   callLoginApi()
                   return
               }
                else
                {
                    Toast.show(message: "Please enter a valid email", controller: self)
                    return
                }
            }
            else
            {
//                if tfPhone.text! == "9779780544"
//                {
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
//                    vc.phoneNumber = "9779780544"
//                    vc.email = self.email
//                    self.navigationController?.pushViewController(vc, animated: true)
//
//                }
//                else
//                {
                    callLoginApi()
//                }
            }
            
        
        }
    }
    func callLoginApi()
    {
        let phoneNumber =  (tfCountryCode.text == "USA" + " ▼" ? "1" : "380") + tfPhone.text!
        var params = ["grantType" : "phone_number" ,"phoneNumber" :  tfPhone.text!,"countryCode": lblCode.text!] as [String : Any]
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
      //  PickerView()
        myPickerView.showCountriesList(from: self)
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

extension PhonenumberScreenVC
{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.tfCountryCode.text = country.code + " ▼"
        self.imgFlag.image = country.flag
        self.lblCode.text = country.phoneCode
    }
    func getWidth(text: String) -> CGFloat
   {
       let txtField = UITextField(frame: .zero)
       txtField.text = text
       txtField.sizeToFit()
       return txtField.frame.size.width
   }

}
extension PhonenumberScreenVC
{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tfPhone
        {
            let prefix = "+1" // What ever you want may be an array and step thru it
            guard tfPhone.text!.hasPrefix(prefix) else { return }
            tfPhone.text  = String(tfPhone.text!.dropFirst(prefix.count).trimmingCharacters(in: .whitespacesAndNewlines))

        }
    }
    
}
