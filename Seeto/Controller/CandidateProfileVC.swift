//
//  CandidateProfileVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 06/01/23.
//

import UIKit
import AVKit
import MobileCoreServices
import SwiftLoader

class CandidateProfileVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate, SearchAddressProtocol{
    func adressMap(address: String) {
        for i in 0...dictTable.count - 1
        {
            if dictTable[i]["title"] == "Current Location"
            {
                dictTable[i]["value"] = address
            }
        }
        tblCandidateProfile.reloadData()
    }
    
    @IBOutlet var topLbl: NSLayoutConstraint!
    @IBOutlet var lblMain: UILabel!
    let imagePicker = UIImagePickerController()
    @IBOutlet var btnNext: UIButton!
    var updateScreen = false
    var task = URLSessionDataTask.init()
    var sizeItem = CGFloat.init()

    var urlVideo = URL(string: "")
    var dataJson = NSDictionary.init()

    var videoUrlString = ""
    var langList = [NSDictionary].init()
    var dictTable = [["title":"Upload Profile Picture","type":"btn","required":"false","value":""],["title":"Name","type":"text","required":"true","value":""],["title":"Last Name","type":"text","required":"true","value":""],["title":"Date of Birth","type":"drop","required":"true","value":""],["title":"+1 0000000000","type":"text","required":"true","value":UserDefaults.standard.value(forKey: "phone") as? String ?? ""],["title":"Email Address","type":"text","required":"true","value": UserDefaults.standard.value(forKey: "email") as? String ?? ""],["title":"Linkedin Profile","type":"text","required":"true","value":""],["title":"Current Location","type":"btn","required":"false","value":""],["title":"Current Position","type":"text","required":"false","value":""],["title":"Experience Level","type":"drop","required":"false","value":""],["title":"Desired Monthly Income","type":"text","required":"false","value":""],["title":"Spoken Language","type":"drop","required":"false","value":""],["title":"Education","type":"btn","required":"false","value":""],["title":"Working Experience","type":"btn","required":"false","value":""],["title":"Gender","type":"drop","required":"false","value":""],["title":"Disabilities","type":"text","required":"false","value":""],["title":"Veteran Status","type":"text","required":"false","value":""],["title":"Military Status","type":"text","required":"false","value":""]]
    var myPickerView : UIPickerView!
    var pickerArray = ["USA","UKR"]
    let toolBar = UIToolbar()
    var index = 0
    var pickerViewTf = UITextField()
    var pickerString = ""
    var textFieldTag = 0
    var datePicker = UIDatePicker()
    let toolbar = UIToolbar();
    var countryCode = "USA"
    var langArray = [] as! [String]
    @IBOutlet var tblCandidateProfile: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.navigationController?.isNavigationBarHidden = true
        tblCandidateProfile.backgroundColor = backGroundColor
        PickerView()
        showDatePicker()
        imagePicker.delegate = self
       // getCandidateProfileApi()
        btnNext.addTarget(self, action: #selector(btnCreateVideoAct), for: .touchUpInside)
        if updateScreen == true
        {
            setUpUpdateScreen()
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
    }

    func setUpUpdateScreen()
    {
        dictTable.remove(at: 0)
        lblMain.isHidden = true
        topLbl.constant = 10
        btnNext.isHidden = true
      //  + " " +  ((dataJson["data"] as! NSDictionary)["lastName"] as! String)
        dictTable[0]["value"] = ((dataJson["data"] as! NSDictionary)["firstName"] as? String) ?? ""
        dictTable[1]["value"] = ((dataJson["data"] as! NSDictionary)["lastName"] as? String) ?? ""
        dictTable[2]["value"] = ((dataJson["data"] as! NSDictionary)["dateOfBirth"] as? String) ?? ""
        dictTable[3]["value"] = ((dataJson["data"] as! NSDictionary)["phoneNumber"] as? String) ?? ""
        dictTable[4]["value"] = ((dataJson["data"] as! NSDictionary)["email"] as? String) ?? ""
        dictTable[5]["value"] = ((dataJson["data"] as! NSDictionary)["linkedInProfile"] as? String) ?? ""
        dictTable[6]["value"] = ((dataJson["data"] as! NSDictionary)["currentLocation"] as? String) ?? ""
        dictTable[7]["value"] = ((dataJson["data"] as! NSDictionary)["currentPosition"] as? String) ?? ""
        dictTable[8]["value"] = experienceArray[((dataJson["data"] as! NSDictionary)["experienceLevel"] as? Int) ?? 0]
        dictTable[9]["value"] = String(describing: ((dataJson["data"] as! NSDictionary)["desiredMonthlyIncome"] as AnyObject))
        dictTable[10]["value"] = ""
        dictTable[11]["value"] = ((dataJson["data"] as! NSDictionary)["education"] as? String) ?? ""
        dictTable[12]["value"] = String(describing: ((dataJson["data"] as! NSDictionary)["workExperience"] as AnyObject))
        dictTable[13]["value"] = String(describing: ((dataJson["data"] as! NSDictionary)["gender"] as AnyObject)) == "1" ? "Male" : "Female"
        dictTable[14]["value"] = ((dataJson["data"] as! NSDictionary)["disability"] as! String)
        dictTable[15]["value"] = ((dataJson["data"] as! NSDictionary)["veteranStatus"] as! String)
        dictTable[16]["value"] = ((dataJson["data"] as! NSDictionary)["militaryStatus"] as? String) ?? ""
        
        langList = ((dataJson["data"] as! NSDictionary)["languageList"] as! [NSDictionary])
        for i in langList
        {
            langArray.append(i["language"] as! String)
        }
    }
    
    @objc func updateCandidateProfileApi()
    {
        ApiManager().postRequest(parameters: updateCandidateDict(),api:  ApiManager.shared.UpdateCandidateProfile) { dataJson, error in
            if let error = error
            {
                DispatchQueue.main.async {
                    self.showToast(message: error.localizedDescription)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else
            {
            if let dataJson = dataJson
                {
              if String(describing: (dataJson["statusCode"] as AnyObject)) == "200"
                {
                if let dict = dataJson["data"] as? NSDictionary{
                  }
                  print(dataJson)
                  DispatchQueue.main.async {
                      self.showToast(message: "Sucessfully Updated")

                      self.navigationController?.popViewController(animated: true)
                  }

                }
                else
                {
                    DispatchQueue.main.async {

                      //  self.showToast(message: ()
               //   Toast.show(message:(dataJson["returnMessage"] as! [String])[0], controller: self)
                    }

                }
                
            }

            }
        }
    }


    func updateCandidateProfileData() -> [String : Any]
    {
        langList.removeAll()
        for i in langArray
        {
            langList.append(["language" : i,"fluencyLevel" : 0])
        }
       return [
            "userType" : 2,
            "firstName" : dictTable[1]["value"]!,
            "lastName" : dictTable[2]["value"]!,
            "dateOfBirth" : dictTable[3]["value"]!,
            "profileImage" : dictTable[0]["value"] ?? "",
            "linkedInProfile" : dictTable[6]["value"]!,
            "phoneNumber" :  dictTable[4]["value"]!,
            "email" :  dictTable[5]["value"]!,
            "experienceLevel" :   ExperienceLevel(rawValue: dictTable[9]["value"]!)?.id ?? 0,
            "desiredMonthlyIncome" : dictTable[10]["value"]! == "" ? "0" : dictTable[10]["value"]!,
            "education" : dictTable[12]["value"]!,
            "workExperience" : dictTable[13]["value"]!,
            "gender" : dictTable[13]["value"]! == "" ? nil : dictTable[13]["value"]! == "Male" ? 1 : 2,
            "disability" : dictTable[15]["value"]!,
            "veteranStatus" : dictTable[16]["value"]!,
            "country" : "America",
            "region" : "California",
            "city" : "Cali",
            "currentLocation" : dictTable[7]["value"]!,
            "latitude" : 0,
            "longitude" : 0,
            "currentPosition" : dictTable[8]["value"]!,
            "jobType" : 0,
            "videoUrl": videoUrlString,
            "bio" : "",
            "militaryStatus":dictTable[17]["value"]!,
            "languageList" : langList
        ] as [String : Any]
    }
    
    
    func updateCandidateDict() -> [String : Any]
    {
        langList.removeAll()

        for i in langArray
        {
            langList.append(["language" : i,"fluencyLevel" : 0])
        }
       return [
            "userType" : 2,
            "firstName" : dictTable[0]["value"]!,
            "lastName" : dictTable[1]["value"]!,
            "dateOfBirth" : dictTable[2]["value"]!,
            "phoneNumber" :  dictTable[3]["value"]!,
            "email" :  dictTable[4]["value"]!,
            "linkedInProfile" : dictTable[5]["value"]!,
            "experienceLevel" :   ExperienceLevel(rawValue: dictTable[8]["value"]!)?.id ?? 0,
            "desiredMonthlyIncome" : dictTable[9]["value"]! == "" ? "0" : dictTable[9]["value"]!,
            "education" : dictTable[11]["value"]!,
            "workExperience" : dictTable[12]["value"]!,
            "gender" : dictTable[13]["value"]! == "" ? 0 : dictTable[13]["value"]! ==  "Male" ? 1 : 2,
            "disability" : dictTable[14]["value"]!,
            "veteranStatus" : dictTable[15]["value"]!,
            "country" : "America",
            "region" : "California",
            "city" : "Cali",
            "currentLocation" : dictTable[6]["value"]!,
            "latitude" : 0,
            "longitude" : 0,
            "currentPosition" : dictTable[7]["value"]!,
            "jobType" : 0,
            "bio" :"",
            "militaryStatus":dictTable[16]["value"]!,
            "languageList" : langList
        ] as [String : Any]
    }

    
   
    func PickerView(){
       // UIPickerView
       self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
       self.myPickerView.delegate = self
       self.myPickerView.dataSource = self
       self.myPickerView.backgroundColor = UIColor.white
       // ToolBar
       toolBar.barStyle = .default
       toolBar.isTranslucent = true
       toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
       toolBar.sizeToFit()

       // Adding Button ToolBar
       let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CandidateProfileVC.doneClick))
        doneButton.tintColor = UIColor.black
       let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
       let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(CandidateProfileVC.cancelClick))
        cancelButton.tintColor = UIColor.black

       toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
       toolBar.isUserInteractionEnabled = true
    }
    
    func showDatePicker(){
      //Formate Date
      datePicker.datePickerMode = .date
      datePicker.preferredDatePickerStyle = .wheels
        //ToolBar
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolbar.sizeToFit()

     let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        doneButton.tintColor = UIColor.black

        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        cancelButton.tintColor = UIColor.black

   toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)


   }

    @objc func donedatePicker(){

     let formatter = DateFormatter()
     formatter.dateFormat = "dd/MM/yyyy"
     dictTable[textFieldTag]["value"] = formatter.string(from: datePicker.date)
     self.view.endEditing(true)
   }

   @objc func cancelDatePicker(){
      self.view.endEditing(true)
    }
    @objc func doneClick() {
        dictTable[textFieldTag]["value"] = pickerArray[index]
        
        pickerViewTf.resignFirstResponder()
        if updateScreen == true
        {
            if textFieldTag == 10
            {
                langArray.append(pickerArray[index])
                tblCandidateProfile.reloadData()

            }
        }
        else
        {
            if textFieldTag == 11
            {
                langArray.append(pickerArray[index])
                tblCandidateProfile.reloadData()

            }
        }
       
     }
    @objc func cancelClick() {
        pickerViewTf.resignFirstResponder()
    }

    func localToUTC(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "H:mm:ss"
        
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    @IBAction func btnBackAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
     func cameraGallery()
    {
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
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


    func openCamera()
        {
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
            {
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
            else
            {
                let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.modalPresentationStyle = .fullScreen
                self.present(alert, animated: true, completion: nil)
            }
        }

        func openGallary()
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.modalPresentationStyle = .fullScreen

            self.present(imagePicker, animated: true, completion: nil)
        }
}

extension CandidateProfileVC
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictTable.count
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 110))
        view.backgroundColor = backGroundColor
        let button = UIButton(frame: CGRect(x: 20, y: 40, width: self.view.frame.width - 40, height: 50))
        button.layer.cornerRadius = 10
        button.setTitle( updateScreen == false ? "Create & Record Video" : "Update", for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(btnCreateVideoAct), for: .touchUpInside)
        button.backgroundColor = blueButtonColor
        view.addSubview(button)
        return view
    }
    

        
    
    @objc func btnCreateVideoAct()
    {
        if updateScreen == false
        {
            for i in dictTable
            {
                if i["required"] == "true"
                {
                    if i["value"] == ""
                    {
                        Toast.show(message: "Please enter \(i["title"] ?? "value")", controller: self)
                        return
                    }
                }
            }
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                print("Camera Available")
                
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.allowsEditing = false
                imagePicker.videoQuality = .typeHigh
                
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                print("Camera UnAvaialable")
            }
            
        }
        else
        {
            updateCandidateProfileApi()
        }
    }
    @objc func btnShowNumberPicker(_ sender : UIButton)
    {
        let alert = UIAlertController(title: "", message: "Select Country Code", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "United States", style: .default, handler: { action in
            self.countryCode = "USA"
            self.tblCandidateProfile.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Ukraine", style: .default, handler: { action in
            self.countryCode = "Ukraine"
            self.tblCandidateProfile.reloadData()

        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.backgroundColor = backGroundColor
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier = "CandidateProfileCell"
        tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CandidateProfileCell
        let attributedString = NSMutableAttributedString(
            string: (dictTable[indexPath.row]["title"]!),
            attributes: [NSAttributedString.Key.foregroundColor: grayColor]
        )
        if (dictTable[indexPath.row]["required"]!) == "true"
        {
            let attributedMark = NSMutableAttributedString(
                string: "*",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
            )
            attributedString.append(attributedMark)

            cell.tfMain.attributedPlaceholder = attributedString
        }
        if (dictTable[indexPath.row]["title"]!) == "Date of Birth"
        {
            cell.imgVector.image = UIImage(named: "")
            cell.heightImg.constant = 25
            cell.widthImg.constant = 25
            cell.topImage.constant = 25
        }
        else if (dictTable[indexPath.row]["title"]!) == "Upload Profile Picture"
        {
            cell.imgVector.image = UIImage(imageLiteralResourceName: "upload")
            cell.heightImg.constant = 20
            cell.widthImg.constant = 20
            cell.topImage.constant = 30
            
        }
        else if (dictTable[indexPath.row]["title"]!) == "Education" || (dictTable[indexPath.row]["title"]!) == "Working Experience"
        {
            cell.imgVector.image = UIImage(imageLiteralResourceName: "plus")
            cell.heightImg.constant = 20
            cell.widthImg.constant = 15
            cell.topImage.constant = 30
            
        }
        else
        {
            cell.imgVector.image = UIImage(imageLiteralResourceName: "Vector")
            cell.heightImg.constant = 20
            cell.widthImg.constant = 15
            cell.topImage.constant = 30

        }
        if (dictTable[indexPath.row]["title"]!) == "+1 0000000000"
        {
            cell.leadingTf.constant = 100
            cell.flagPicView.image = countryCode == "USA" ? UIImage(named: "usa") : UIImage(named: "ukr")
            cell.phoneCountryView.isHidden = false
            cell.btnSelectCountryView.tag = indexPath.row
            cell.btnSelectCountryView.addTarget(self, action: #selector(btnShowNumberPicker), for: .touchUpInside)
        }
        else
        {
            cell.leadingTf.constant = 27
            cell.phoneCountryView.isHidden = true
        }
        cell.tfMain.attributedPlaceholder = attributedString
        if (dictTable[indexPath.row]["title"]!) == "Spoken Language"
        {
            cell.tfMain.text = ""
        }
        else
        {
            cell.tfMain.text = (dictTable[indexPath.row]["value"]!)
        }
        if (dictTable[indexPath.row]["type"]!) == "text"
        {
            cell.imgVector.isHidden = true
        }
        else
        {
            cell.imgVector.isHidden = false
        }
        if ((dictTable[indexPath.row]["type"]!) == "btn")
        {
            if (dictTable[indexPath.row]["title"]!) == "Upload Profile Picture" || (dictTable[indexPath.row]["title"]!) == "Current Location"
            {
                cell.tfMain.isUserInteractionEnabled = false
            }
          
            else
            {
                cell.tfMain.isUserInteractionEnabled = true
            }
        }
        else
        {
            cell.tfMain.isUserInteractionEnabled = true

        }

        if (dictTable[indexPath.row]["title"]!) == "Spoken Language" && langArray.count > 0
        {
            cell.colllV.isHidden = false
            cell.colllV.delegate = self
            cell.colllV.dataSource = self
            cell.heightCollV.constant = 50
            cell.colllV.reloadData()
        }
        else
        {
            cell.colllV.isHidden = true
            cell.heightCollV.constant = 0
        }
        cell.tfMain.tag = indexPath.row
        cell.tfMain.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (dictTable[indexPath.row]["type"]!) == "btn"
        {
            if (dictTable[indexPath.row]["title"]!) == "Upload Profile Picture"
            {
                cameraGallery()
            }
             else if (dictTable[indexPath.row]["title"]!) == "Current Location"
            {
                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
                 vc.searchAdressDelegate = self
                 self.navigationController?.pushViewController(vc, animated: true)

             }
           
        }
    }
}

extension CandidateProfileVC : UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return  (dictTable[textFieldTag]["title"]!) == "Spoken Language" ? 2 : 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (dictTable[textFieldTag]["title"]!) == "Spoken Language" ? component == 0 ? pickerArray.count : languageArray.count   : pickerArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (dictTable[textFieldTag]["title"]!) == "Spoken Language" ? component == 0 ? pickerArray[row] : languageArray[row]   : pickerArray[row]
        return (dictTable[textFieldTag]["title"]!) == "Spoken Language" ? component == 0 ? pickerArray[row] : languageArray[row]   : pickerArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        index = row
    }}
extension CandidateProfileVC : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldTag = textField.tag
        if (dictTable[textFieldTag]["type"]!) == "drop"
        {
          

      
        if (dictTable[textFieldTag]["title"]!) == "Current Location"
        {
            pickerArray = ["Ropar","Mansa"]
        }
        else if (dictTable[textFieldTag]["title"]!) == "Experience Level"
        {
            DispatchQueue.main.async { [self] in
                pickerArray = ExperienceLevel.allCases.map { $0.rawValue }

            }        }
        else if (dictTable[textFieldTag]["title"]!) == "Spoken Language"
        {
            pickerArray = ["Eng","Hin"]
        }else if (dictTable[textFieldTag]["title"]!) == "Gender"
        {
            pickerArray = ["Male","Female"]
        }
            if (dictTable[textFieldTag]["title"]!) == "Date of Birth"
            {
                pickerArray = []
                pickerViewTf = UITextField()
                textField.inputView = datePicker
                textField.inputAccessoryView = toolbar

            }
            else
            {
                pickerViewTf = textField
                textField.inputView = myPickerView
                textField.inputAccessoryView = toolBar
                index = 0
                self.myPickerView.selectRow(0, inComponent: 0, animated: false)

            }
        }
        else if (dictTable[textFieldTag]["type"]!) == "btn"
        {
            pickerArray = []
            pickerViewTf = UITextField()

            textField.inputView = .none
            textField.inputAccessoryView = nil
            if (dictTable[textFieldTag]["title"]!) == "Upload Profile Picture"
            {
                cameraGallery()
            }
            
                

        }
        else
        {
            pickerViewTf = UITextField()
            textField.inputView = .none
            textField.inputAccessoryView = nil

        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
                  let textRange = Range(range, in: text) {
                  let updatedText = text.replacingCharacters(in: textRange,
                                                              with: string)
            if (dictTable[textFieldTag]["type"]!) == "text" || (dictTable[textFieldTag]["type"]!) == "btn"
            {
                (dictTable[textFieldTag]["value"]) = updatedText
            }
            
        }
           
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        tblCandidateProfile.reloadData()
    }
}
// MARK: - UIImagePickerControllerDelegate
extension CandidateProfileVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)

        guard
            let mediaType = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaType.rawValue) ] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaURL.rawValue) ] as? URL,
            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
            else {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
           
            uploadImage(paramName: "file", fileName: "ProfileImage.png", image: image)
                return
        }
    urlVideo = url
        let dataVideo = NSData(contentsOf: url as URL)!
        print("File size before compression: \(Double(dataVideo.length / 1048576)) mb")
              let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".m4v")
    compressVideo(inputURL: url , outputURL: compressedURL) { (exportSession) in
                      guard let session = exportSession else {
                          return
                      }

                      switch session.status {
                      case .unknown:
                          break
                      case .waiting:
                          break
                      case .exporting:
                          break
                      case .completed:
                          guard let compressedData = NSData(contentsOf: compressedURL) else {
                              return
                          }
                          self.sizeItem = CGFloat(compressedData.length)
//                          DispatchQueue.main.asyncAfter(deadline: .now() + 1)
//                          {
                              print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
                              self.uploadVideo(paramName: "file", fileName: "ProfileVideo.mp4", dataVideo: compressedData as Data,url: compressedURL)
                      //    }

                      case .failed:
                          break
                      case .cancelled:
                          break
                      }
                  }
        // Handle a movie capture
      
    }
    func uploadVideo(paramName: String, fileName: String, dataVideo: Data,url : URL) {

        let url = URL(string: "http://34.207.158.183/api/v1.0/User/UploadFile")

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

        let session = URLSession.shared

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: video/mp4\r\n\r\n".data(using: .utf8)!)
        data.append(dataVideo)

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
        self.task = session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .mutableContainers)
                if let json = jsonData as? [String: Any] {
                    if let dict = json["data"] as? NSDictionary{
                        DispatchQueue.main.async {
                            SwiftLoader.hide()

                            self.videoUrlString = (dict["url"] as? String) ?? ""

                            UISaveVideoAtPathToSavedPhotosAlbum(
                                url!.path,
                                self,
                                #selector(self.video(_:didFinishSavingWithError:contextInfo:)),
                                nil)

                        }
                      }
                    print(json)
                }
                SwiftLoader.hide()

            }
            else
            {
                SwiftLoader.hide()

                print(error?.localizedDescription)
            }
        })
        task.progress.addObserver(self, forKeyPath: #keyPath(Progress.fractionCompleted), options: .new, context: nil)

        task.resume()
    }
    // observe progress and update progress view
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(Progress.fractionCompleted) {
            let uploadedBytes = task.countOfBytesSent
            let percentageUploaded = Double(uploadedBytes) / Double(sizeItem) * 100
            let roundedOffValue = Int(percentageUploaded)
            // update progress view
            DispatchQueue.main.async {
                SwiftLoader.show(title: "\(roundedOffValue)%", animated: true)
            }
        }
    }
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
           let urlAsset = AVURLAsset(url: inputURL, options: nil)
           guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPreset960x540) else {
               handler(nil)

               return
           }

           exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
           exportSession.shouldOptimizeForNetworkUse = true
           exportSession.exportAsynchronously { () -> Void in
               handler(exportSession)
           }
       }
    func uploadImage(paramName: String, fileName: String, image: UIImage) {
        SwiftLoader.show(animated: true)
        let url = URL(string: "http://34.207.158.183/api/v1.0/User/UploadFile")

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

        let session = URLSession.shared

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .mutableContainers)
                if let json = jsonData as? [String: Any] {
                    if let dict = json["data"] as? NSDictionary{
                        self.dictTable[0]["value"] = (dict["url"] as? String) ?? ""
                        SwiftLoader.hide()
                        DispatchQueue.main.async {
                            self.tblCandidateProfile.reloadData()
                        }
                      
                      }
                    print(json)

                }
                SwiftLoader.hide()

            }
            else
            {
                SwiftLoader.hide()
                print(error?.localizedDescription)
            }
        }).resume()
    }
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
      let title = "Success"
      let message = "Video was saved"

      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler:{_ in  print("Foo")
          let vc = self.storyboard?.instantiateViewController(withIdentifier: "ThumbnailVideoVC") as! ThumbnailVideoVC
          vc.urlVideo = self.urlVideo
          vc.dictParam = self.updateCandidateProfileData()
          self.navigationController?.pushViewController(vc, animated: true)
      }
                                   ))
      present(alert, animated: true, completion: nil)
  }
}

extension CandidateProfileVC: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    // Bare bones implementation
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: need to implement
        
        return langArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: need to implem,ent
        collectionView.register(UINib(nibName: "SpokenLanguageCell", bundle: nil), forCellWithReuseIdentifier: "SpokenLanguageCell")

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpokenLanguageCell", for: indexPath) as! SpokenLanguageCell
        cell.lblLang.text = langArray[indexPath.row]
        cell.btnCross.tag = indexPath.row
        cell.btnCross.addTarget(self, action: #selector(self.btnCross(_:)), for: .touchUpInside)
          return cell
        
    }
 
    @objc func btnCross(_ sender : UIButton)
    {
        langArray.remove(at: sender.tag)
        DispatchQueue.main.async {
            self.tblCandidateProfile.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 50)
    }
}
