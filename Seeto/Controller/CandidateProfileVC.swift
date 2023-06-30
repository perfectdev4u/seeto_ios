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
import CountryPickerView
import Photos
import CropViewController
class CandidateProfileVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate, SearchAddressProtocol, CountryPickerViewDelegate, CountryPickerViewDataSource, SearchIndustryProtocol, CropViewControllerDelegate{
    func industryString(string: String, id: Int) {
        for i in 0...dictTable.count - 1
        {
            if dictTable[i]["title"] == "Industry"
            {
                dictTable[i]["value"] = string
            }
        }
        industryId = id
        DispatchQueue.main.async {
            self.tblCandidateProfile.reloadData()
        }
    }
    var languageArrayMain = LanguageLevel.allCases.map { $0.rawValue }

    
    var flagImage = UIImage(named: "usa")
    var profileImage = UIImage(named: "placeholderImg")
    var langLevelArray = ["Not Selected","Beginner","Pre Intermediate","Intermediate","Upper Intermediate", "Advanced","Fluent"]
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
    var countryPickerView: CountryPickerView!
     var startAnimation = false
    @IBOutlet var topLbl: NSLayoutConstraint!
    @IBOutlet var lblMain: UILabel!
    let imagePicker = UIImagePickerController()
    @IBOutlet var btnNext: UIButton!
    var updateScreen = false
    var task = URLSessionDataTask.init()
    var sizeItem = CGFloat.init()
    var industryId = 0
    var mainIndustryArray = [String]()
    var mainIndustryIdArray = [Int]()

    var urlVideo = URL(string: "")
    var dataJson = NSDictionary.init()

    var videoUrlString = ""
    var langList = [NSDictionary].init()
    var dictTable = [["title":"Upload Profile Picture","type":"btn","required":"false","value":""],["title":"First Name","type":"text","required":"true","value":""],["title":"Last Name","type":"text","required":"true","value":""],["title":"Industry","type":"btn","required":"false","value":""],["title":"Date of Birth","type":"drop","required":"true","value":""],["title":"+1 0000000000","type":"text","required":"true","value":UserDefaults.standard.value(forKey: "phone") as? String ?? ""],["title":"Email Address","type":"text","required":"true","value": UserDefaults.standard.value(forKey: "email") as? String ?? ""],["title":"Linkedin Profile","type":"text","required":"false","value":""],["title":"Current Location","type":"btn","required":"false","value":""],["title":"Current Position","type":"text","required":"false","value":""],["title":"Experience Level","type":"drop","required":"false","value":""],["title":"Desired Monthly Income (U.S. Dollars)","type":"text","required":"false","value":""],["title":"Spoken Language","type":"drop","required":"false","value":""],["title":"Education","type":"btn","required":"false","value":""],["title":"Working Experience","type":"btn","required":"false","value":""],["title":"Gender","type":"drop","required":"false","value":""],["title":"Disabilities","type":"text","required":"false","value":""],["title":"Veteran Status","type":"text","required":"false","value":""],["title":"Military Status","type":"text","required":"false","value":""]]
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
    var langFluencyArray = [] as! [Int]
    var profilePicUrl = ""
    @IBOutlet var tblCandidateProfile: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        self.navigationController?.isNavigationBarHidden = true
        tblCandidateProfile.backgroundColor = backGroundColor
        PickerView()
        showDatePicker()
        imagePicker.delegate = self
        getIndustryApi()
       // getCandidateProfileApi()
        btnNext.addTarget(self, action: #selector(btnCreateVideoAct), for: .touchUpInside)
        if updateScreen == true
        {
            setUpUpdateScreen()
        }
        setCountryPickerView()
        // Do any additional setup after loading the view.
    }
    func getIndustryApi()
    {
        ApiManager().postRequest(parameters: ["page": 1,"pageSize": 1000],api:  ApiManager.shared.GetAllIndustries) { dataJson, error in
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
                if let dictArray = dataJson["data"] as? [NSDictionary]{
                    DispatchQueue.main.async {
                       for item in dictArray
                        {
                           self.mainIndustryArray.append((item["industryName"] as? String) ?? "")
                           self.mainIndustryIdArray.append((item["industryId"] as? Int) ?? 0)
                       }
                        
                    }
                  }



                }
                else
                {
                    DispatchQueue.main.async {

                      //  self.showToast(message: ()
                  Toast.show(message:"Error", controller: self)
                    }

                }
                
            }

            }
        }
    }

    func setCountryPickerView(){
       // UIPickerView
       self.countryPickerView = CountryPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
       self.countryPickerView.delegate = self
       self.countryPickerView.dataSource = self
       self.countryPickerView.backgroundColor = UIColor.white
       // ToolBar
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
        industryId = ((dataJson["data"] as! NSDictionary)["industryId"] as? Int) ?? 0

      //  + " " +  ((dataJson["data"] as! NSDictionary)["lastName"] as! String)
        dictTable[0]["value"] = ((dataJson["data"] as! NSDictionary)["firstName"] as? String) ?? ""
        dictTable[1]["value"] = ((dataJson["data"] as! NSDictionary)["lastName"] as? String) ?? ""
        dictTable[2]["value"] = ((dataJson["data"] as! NSDictionary)["industry"] as? String) ?? ""
        dictTable[3]["value"] = converrDateFormat(string: ((dataJson["data"] as! NSDictionary)["dateOfBirth"] as? String) ?? "")
        dictTable[4]["value"] = ((dataJson["data"] as! NSDictionary)["phoneNumber"] as? String) ?? ""
        dictTable[5]["value"] = ((dataJson["data"] as! NSDictionary)["email"] as? String) ?? ""
        dictTable[6]["value"] = ((dataJson["data"] as! NSDictionary)["linkedInProfile"] as? String) ?? ""
        dictTable[7]["value"] = ((dataJson["data"] as! NSDictionary)["currentLocation"] as? String) ?? ""
        dictTable[8]["value"] = ((dataJson["data"] as! NSDictionary)["currentPosition"] as? String) ?? ""
        dictTable[9]["value"] = experienceArray[((dataJson["data"] as! NSDictionary)["experienceLevel"] as? Int) ?? 0]
        dictTable[10]["value"] = String(describing: ((dataJson["data"] as! NSDictionary)["desiredMonthlyIncome"] as AnyObject))
        dictTable[11]["value"] = ""
//        educationList
//
        var count = 1
        if let array = ((dataJson["data"] as! NSDictionary)["educationList"] as? [NSDictionary])
        {
            if array.count > 0
            {
                for i in 0...array.count - 1
                {
                    if i == 0
                    {
                        dictTable[12]["value"] = (array[0]["education"] as? String) ?? ""
                    }
                    else
                    {
                        count += 1
                        dictTable[12 + i - 1]["type"] = "text"

                        dictTable.insert(["title":"Education" + " \(i + 1)","type":"btn","required":"false","value":(array[i]["education"] as? String) ?? ""], at: 12 + i)
                    }
                }
            }
        }
        if let array = ((dataJson["data"] as! NSDictionary)["experienceList"] as? [NSDictionary])
        {
            if array.count > 0
            {
                for i in 0...array.count - 1
                {
                    if i == 0
                    {
                        dictTable[12 + count]["value"] = (array[0]["experience"] as? String) ?? ""
                    }
                    else
                    {
                        dictTable[12 + count + i - 1]["type"] = "text"
                        dictTable.insert(["title":"Working Experience" + " \(i + 1)","type":"btn","required":"false","value":(array[i]["experience"] as? String) ?? ""], at: 12 + count + i)
                    }
                }
            }
        }
        setValueForTitle(title: "Gender", value: String(describing: ((dataJson["data"] as! NSDictionary)["gender"] as AnyObject)) == "0" ?  "" : String(describing: ((dataJson["data"] as! NSDictionary)["gender"] as AnyObject)) == "1" ? "Male" : "Female")
        setValueForTitle(title: "Disabilities", value: ((dataJson["data"] as! NSDictionary)["disability"] as! String))
        setValueForTitle(title: "Veteran Status", value: ((dataJson["data"] as! NSDictionary)["veteranStatus"] as! String))
        setValueForTitle(title: "Military Status", value: ((dataJson["data"] as! NSDictionary)["militaryStatus"] as? String) ?? "")

        
        langList = ((dataJson["data"] as! NSDictionary)["languageList"] as! [NSDictionary])
        for i in langList
        {
            langArray.append(i["language"] as! String)
            langFluencyArray.append(i["fluencyLevel"] as! Int)
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
                        Toast.show(message:(dataJson["title"] as? String) ?? errorMessage , controller: self)
                    }

                }
                
            }

            }
        }
    }


    func updateCandidateProfileData() -> [String : Any]
    {
        langList.removeAll()
        if langArray.count > 0
        {
            for i in 0...langArray.count - 1
            {
                langList.append(["language" : langArray[i],"fluencyLevel" : langFluencyArray[i]])
                
            }
        }
       return [
            "userType" : 2,
            "firstName" : dictTable[1]["value"]!,
            "lastName" : dictTable[2]["value"]!,
            "industry":dictTable[3]["value"]!,
            "industryId": industryId,
            "dateOfBirth" : dictTable[4]["value"]!,
            "profileImage" : self.profilePicUrl,
            "linkedInProfile" : dictTable[7]["value"]!,
            "phoneNumber" :  dictTable[5]["value"]!,
            "email" :  dictTable[6]["value"]!,
            "experienceLevel" :   ExperienceLevel(rawValue: dictTable[10]["value"]!)?.id ?? 0,
            "desiredMonthlyIncome" : dictTable[11]["value"]! == "" ? "0" : dictTable[11]["value"]!,
            "educationList" : getArrayFromTitleEdu(title: "Education",key: "education"),
            "experienceList" : getArrayFromTitleWork(title: "Working Experience",key: "experience"),
            "gender" : getValueFromTitle(title: "Gender") == "" ? 0 : getValueFromTitle(title: "Gender") == "Male" ? 1 : 2,
            "disability" : getValueFromTitle(title: "Disabilities"),
            "veteranStatus" : getValueFromTitle(title: "Veteran Status"),
            "country" : "America",
            "region" : "California",
            "city" : "Cali",
            "currentLocation" : dictTable[8]["value"]!,
            "latitude" : 0,
            "longitude" : 0,
            "currentPosition" : dictTable[9]["value"]!,
            "jobType" : 0,
            "videoUrl": videoUrlString,
            "bio" : "",
            "militaryStatus":getValueFromTitle(title: "Military Status"),
            "languageList" : langList
        ] as [String : Any]
    }
    
    
    func updateCandidateDict() -> [String : Any]
    {
        langList.removeAll()
        if langArray.count > 0
        {
            for i in 0...langArray.count - 1
            {
                langList.append(["language" : langArray[i],"fluencyLevel" : langFluencyArray[i]])
                
            }
        }
       return [
            "userType" : 2,
            "firstName" : dictTable[0]["value"]!,
            "lastName" : dictTable[1]["value"]!,
            "industry":dictTable[2]["value"]!,
            "industryId": industryId,
            "dateOfBirth" : dictTable[3]["value"]!,
            "phoneNumber" :  dictTable[4]["value"]!,
            "email" :  dictTable[5]["value"]!,
            "linkedInProfile" : dictTable[6]["value"]!,
            "experienceLevel" :   ExperienceLevel(rawValue: dictTable[9]["value"]!)?.id ?? 0,
            "desiredMonthlyIncome" : dictTable[10]["value"]! == "" ? "0" : dictTable[10]["value"]!,
            "educationList" : getArrayFromTitleEdu(title: "Education",key: "education"),
            "experienceList" : getArrayFromTitleWork(title: "Working Experience",key: "experience"),
            "gender" : getValueFromTitle(title: "Gender") == "" ? 0 : getValueFromTitle(title: "Gender") == "Male" ? 1 : 2,
            "disability" : getValueFromTitle(title: "Disabilities"),
            "veteranStatus" : getValueFromTitle(title: "Veteran Status"),
            "country" : "America",
            "region" : "California",
            "city" : "Cali",
            "currentLocation" : dictTable[7]["value"]!,
            "latitude" : 0,
            "longitude" : 0,
            "currentPosition" : dictTable[8]["value"]!,
            "jobType" : 0,
            "bio" :"",
            "militaryStatus":getValueFromTitle(title: "Military Status"),
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
     formatter.dateFormat = "yyyy-MM-dd"
     dictTable[textFieldTag]["value"] = formatter.string(from: datePicker.date)
     self.view.endEditing(true)
   }

   @objc func cancelDatePicker(){
      self.view.endEditing(true)
    }
    var indexLang = 0
    @objc func doneClick() {
       
            dictTable[textFieldTag]["value"] = pickerArray[index]
            pickerViewTf.resignFirstResponder()
            if updateScreen == true
            {
                if textFieldTag == 11
                {
                //    dictTable[textFieldTag]["value"] = pickerArray[index] + " (" +  languageArray[indexLang] + ")"
                    if langArray.contains(pickerArray[index])
                    {
                        Toast.show(message: "You can't add same language multiple times!", controller: self)
                    }
                    else
                    {
                        langArray.append(pickerArray[index])
                        langFluencyArray.append(indexLang)
                    }
                }
            }
            else
            {
                if textFieldTag == 12
                {
             //       dictTable[textFieldTag]["value"] = pickerArray[index] + " (" +  languageArray[indexLang] + ")"
                    if langArray.contains(pickerArray[index])
                    {
                        Toast.show(message: "You can't add same language multiple times!", controller: self)
                    }
                    else
                    {
                        langArray.append(pickerArray[index])
                        langFluencyArray.append(indexLang)
                    }
                }
            }
        DispatchQueue.main.async {
            self.tblCandidateProfile.reloadData()

        }
       
     }
    @objc func cancelClick() {
        pickerViewTf.resignFirstResponder()
    }

    func localToUTC(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
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

    func cameraGalleryVideo()
   {
       
       let alert = UIAlertController(title: "Choose", message: nil, preferredStyle: .actionSheet)
       alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
           self.openCameraVideo()
       }))
       
       alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
           self.openGallaryVideo()
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
    func openCameraVideo()
        {
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
            {
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.allowsEditing = false
                imagePicker.videoQuality = .typeMedium
                imagePicker.cameraDevice = .front
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
   
        



    func presentCropViewController(image : UIImage)
    {
        let cropViewController = CropViewController(croppingStyle: .circular, image: image)
        cropViewController.delegate = self
        self.present(cropViewController, animated: true, completion: nil)
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: {
            
            self.uploadImage(paramName: "file", fileName: "        Profile.png", image: image.convert(toSize:CGSize(width:100.0, height:100.0), scale: UIScreen.main.scale))
        })

    }
                                   
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: {
                self.startAnimation = false

                })
    }

        func openGallaryVideo()
        {
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.mediaTypes = ["public.movie"]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    func openCamera()
        {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                print("Camera Available")
                
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
           //     imagePicker.allowsEditing = true
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
            imagePicker.allowsEditing = false
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
            for i in dictTable
            {
                if i["title"] == "Linkedin Profile"
                {
                    if i["value"]! != ""
                    {
                        if i["value"]!.contains("https://")
                        {
                            if i["value"]?.isValidURL() == false
                            {
                                Toast.show(message: "Please enter valid Linkedin Profile url", controller: self)
                                return
                            }
                        }
                        else
                        {
                            if  ("https://" + i["value"]!).isValidURL() == false
                            {
                                Toast.show(message: "Please enter valid Linkedin Profile url", controller: self)
                                return
                            }
                        }
                    }
                }
            }
            cameraGalleryVideo()

            
            
        }
        else
        {
            updateCandidateProfileApi()
        }
    }
    @objc func btnShowNumberPicker(_ sender : UIButton)
    {
        countryPickerView.showCountriesList(from: self)

//        let alert = UIAlertController(title: "", message: "Select Country Code", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "United States", style: .default, handler: { action in
//            self.countryCode = "USA"
//            self.tblCandidateProfile.reloadData()
//        }))
//        alert.addAction(UIAlertAction(title: "Ukraine", style: .default, handler: { action in
//            self.countryCode = "Ukraine"
//            self.tblCandidateProfile.reloadData()
//
//        }))
//        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 110
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
        if (dictTable[indexPath.row]["title"]!) == "Upload Profile Picture"
        {
            let identifier = "LogoViewCell"
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! LogoViewCell
            cell.imgMain.image = profileImage
            cell.btnEdit.addTarget(self, action: #selector(btnEditImageAct), for: .touchUpInside)
            if startAnimation == false
            {
                cell.activityIndicator.isHidden = true
                cell.activityIndicator.stopAnimating()
            }
            else
            {
                cell.activityIndicator.isHidden = false
                cell.activityIndicator.startAnimating()
            }
            return cell

        }
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
        else if (dictTable[indexPath.row]["title"]!).contains("Education")  || (dictTable[indexPath.row]["title"]!).contains("Working Experience")
        {
            cell.imgVector.image = UIImage(imageLiteralResourceName: "plus")
            cell.heightImg.constant = 20
            cell.widthImg.constant = 15
            cell.topImage.constant = 30
            
        }
        else if (dictTable[indexPath.row]["title"]!).contains("Current Location")
        {
            cell.imgVector.image = UIImage(named: "")
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
        if (dictTable[indexPath.row]["title"]!).contains("0000000000")
        {
            cell.leadingTf.constant = 100
            cell.flagPicView.image =  flagImage
            cell.phoneCountryView.isHidden = false
            cell.btnSelectCountryView.tag = indexPath.row
            cell.btnSelectCountryView.addTarget(self, action: #selector(btnShowNumberPicker), for: .touchUpInside)
        }
        else
        {
            cell.leadingTf.constant = 27
            cell.phoneCountryView.isHidden = true
        }
       
        cell.btnPlus.tag = indexPath.row
        cell.btnPlus.addTarget(self, action: #selector(btnPlusAct), for: .touchUpInside)
        cell.tfMain.attributedPlaceholder = attributedString
        if (dictTable[indexPath.row]["title"]!) == "Spoken Language"
        {
            cell.tfMain.text = ""
        }
        else
        {
            if (dictTable[indexPath.row]["title"]!) == "Desired Monthly Income (U.S. Dollars)" || (dictTable[indexPath.row]["title"]!) == "Linkedin Profile" || (dictTable[indexPath.row]["title"]!) == "+1 0000000000" || (dictTable[indexPath.row]["title"]!) == "+1 0000000000" || (dictTable[indexPath.row]["title"]!) == "Date of Birth" || (dictTable[indexPath.row]["title"]!) == "Email Address"
            {
                cell.tfMain.text = (dictTable[indexPath.row]["value"]!)

            }
            else
            {
                cell.tfMain.text = (dictTable[indexPath.row]["value"]!).capitalizingFirstLetter()
            }
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
            if (dictTable[indexPath.row]["title"]!).contains("Education") == true || (dictTable[indexPath.row]["title"]!).contains("Working Experience")
            {
                cell.btnPlus.isHidden = false
            }
            else
            {
                cell.btnPlus.isHidden = true
                
            }
            if (dictTable[indexPath.row]["title"]!) == "Upload Profile Picture" || (dictTable[indexPath.row]["title"]!) == "Current Location" || (dictTable[indexPath.row]["title"]!) == "Industry"
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
            cell.btnPlus.isHidden = true

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
        if (dictTable[indexPath.row]["title"]!) == "Upload Profile Picture"
        {
            cell.imgProfile.image = profileImage

        }
        else
        {
            cell.imgProfile.image = UIImage(named: "")

        }
        cell.tfMain.tag = indexPath.row
        cell.tfMain.delegate = self
        cell.selectionStyle = .none
        return cell
    }
   
    @objc func btnEditImageAct(_ sender : UIButton)
    {
        cameraGallery()
    }
    @objc func btnPlusAct(_ sender : UIButton)
    {
        if (dictTable[sender.tag]["title"]!).contains("Education")
        {
            var count = 0
            for i in dictTable
            {
                if (i["title"]!).contains("Education") == true
                {
                    count += 1
                }
            }
            (dictTable[sender.tag]["type"]!) = "text"
            dictTable.insert(["title":"Education" + " \(count + 1)","type":"btn","required":"false","value":""], at: sender.tag + 1)
            tblCandidateProfile.reloadData()
        }
        if (dictTable[sender.tag]["title"]!).contains("Working Experience")
        {
            var count = 0
            for i in dictTable
            {
                if (i["title"]!).contains("Working Experience") == true
                {
                    count += 1
                }
            }
            (dictTable[sender.tag]["type"]!) = "text"
            dictTable.insert(["title":"Working Experience" + " \(count + 1)","type":"btn","required":"false","value":""], at: sender.tag + 1)
            tblCandidateProfile.reloadData()
        }
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
            else if (dictTable[indexPath.row]["title"]!) == "Industry"
             {
                  let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
                  vc.searchIndustryDelegate = self
                vc.mainArray = mainIndustryArray
                vc.industryIdArray = mainIndustryIdArray
                vc.forIndustry = true
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
        return (dictTable[textFieldTag]["title"]!) == "Spoken Language" ? component == 0 ? pickerArray.count : languageArrayMain.count   : pickerArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (dictTable[textFieldTag]["title"]!) == "Spoken Language" ? component == 0 ? pickerArray[row] : languageArrayMain[row]   : pickerArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0
        {
            index = row
        }
        else
        {
            indexLang = row
        }
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
            pickerArray = ["English","Russian","Ukranian"]
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
//            let photo = info[.phAsset] as? PHAsset
//            DispatchQueue.main.async {
//                self.tblCandidateProfile.reloadData()
//            }
            startAnimation = true
            DispatchQueue.main.async {
                
                self.tblCandidateProfile.reloadData()
            }
            presentCropViewController(image: image)
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
    //    SwiftLoader.show(animated: true)
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
                        self.profilePicUrl = (dict["url"] as? String) ?? ""
                        self.dictTable[0]["value"] = fileName
                        self.profileImage = image

               //         SwiftLoader.hide()
                        self.startAnimation = false

                        DispatchQueue.main.async {
                            self.tblCandidateProfile.reloadData()
                        }
                      
                      }
                    print(json)

                }
         //       SwiftLoader.hide()

            }
            else
            {
          //      SwiftLoader.hide()
                print(error?.localizedDescription)
            }
        }).resume()
    }
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {

          let vc = self.storyboard?.instantiateViewController(withIdentifier: "ThumbnailVideoVC") as! ThumbnailVideoVC
          vc.urlVideo = self.urlVideo
          vc.dictParam = self.updateCandidateProfileData()
          self.navigationController?.pushViewController(vc, animated: true)
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
        //
        cell.lblLang.text = langArray[indexPath.row] + " (" +  langLevelArray[langFluencyArray[indexPath.row]] + ")"
        cell.btnCross.tag = indexPath.row
        cell.widthLbl.constant = cell.lblLang.intrinsicContentSize.width
        cell.btnCross.addTarget(self, action: #selector(self.btnCross(_:)), for: .touchUpInside)
          return cell
        
    }
 
    @objc func btnCross(_ sender : UIButton)
    {
        print(langArray)
        print(langFluencyArray)
        langArray.remove(at: sender.tag)
        langFluencyArray.remove(at: sender.tag)
        DispatchQueue.main.async {
            self.tblCandidateProfile.reloadData()
        }
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//                return CGSize(width:  (langArray[indexPath.row] + " (" +  langLevelArray[langFluencyArray[indexPath.row]] + ")").size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12,weight: .regular)]).width + 60, height: 50)
////        return CGSize(width: 100, height: 50)
//
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//    }
}

extension CandidateProfileVC
{
    func getValueFromTitle(title : String) -> String
    {
        var value = ""
        for i in dictTable
        {
            if (i["title"]!) == (title)
            {
                value = i["value"] ?? ""
            }
        }
        return value
    }
    func setValueForTitle(title : String ,value : String)
    {
        for i in 0...dictTable.count - 1
        {
            if (dictTable[i]["title"]!) == (title)
            {
                dictTable[i]["value"] = value
            }
        }
    }
    func getArrayFromTitleEdu(title : String,key : String) -> [NSDictionary]
    {
        var value = [NSDictionary].init()
        for i in dictTable
        {
            if (i["title"]!).contains(title) == true
            {
                if (i["value"]!) != ""
                {
                    value.append([key : (i["value"]!)])
                }
            }
          
        }
        return value
    }
    func getArrayFromTitleWork(title : String,key : String) -> [NSDictionary]
    {
        var value = [NSDictionary].init()
        for i in dictTable
        {
            if (i["title"]!).contains(title) == true
            {
                if (i["value"]!) != ""
                {
                    value.append([key : (i["value"]!)])
                }
            }
          
        }
        return value
    }
}

extension CandidateProfileVC
{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
//        self.tfCountryCode.text = country.code + " ▼"
        flagImage = country.flag
        for index in 0...dictTable.count - 1
        {
           if (dictTable[index]["title"]!).contains("0000000000")
            {
               dictTable[index]["title"] = country.phoneCode + " 0000000000"
           }
        }
        tblCandidateProfile.reloadData()
    }
}
