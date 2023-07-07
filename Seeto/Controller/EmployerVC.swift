//
//  EmployerVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 24/01/23.
//

import UIKit
import AVKit
import MobileCoreServices
import SwiftLoader
import CropViewController
class EmployerVC: UIViewController ,UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate, SearchIndustryProtocol, SearchAddressProtocol,CropViewControllerDelegate{
    func adressMap(address: String) {
        for i in 0...dictTable.count - 1
        {
            if dictTable[i]["title"] == "Company Location"
            {
                dictTable[i]["value"] = address
            }
        }
        DispatchQueue.main.async {
            self.tblEmployer.reloadData()
        }
    }
    var industryId = 0
   var companyLogoUrl = ""
    var startAnimation = false
    func industryString(string: String,id : Int) {
        for i in 0...dictTable.count - 1
        {
            if dictTable[i]["title"] == "Industry"
            {
                dictTable[i]["value"] = string
            }
        }
        industryId = id
        DispatchQueue.main.async {
            self.tblEmployer.reloadData()
        }
    }
    var companyImage = UIImage(named: "placeholderImg")

    var dictTable = [["title":"Upload Company Logo","type":"btn","required":"false","value":""],["title":"Company Name","type":"text","required":"true","value":""],["title":"Industry","type":"btn","required":"false","value":""],["title":"Website","type":"text","required":"false","value":""],["title":"LinkedIn Profile","type":"text","required":"false","value":""],["title":"Company Foundation Date","type":"btn","required":"false","value":""],["title":"Company Location","type":"btn","required":"true","value":""],["title":"Company Size","type":"drop","required":"false","value":""]]
    @IBOutlet var lblMain: UILabel!
    let imagePicker = UIImagePickerController()
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var topLbl: NSLayoutConstraint!
    var updateScreen = false
    var dataJson = NSDictionary.init()
    private var selectedDate = MonthYear()
    var urlVideo = URL(string: "")
    var myPickerView : UIPickerView!
    var pickerArray = ["USA","UKR"]
    let toolBar = UIToolbar()
    var index = 0
    var pickerViewTf = UITextField()
    var pickerString = ""
    var textFieldTag = 0
    var datePicker = MonthYearPickerView()
    let toolbar = UIToolbar();
    var countryCode = "USA"
    var mainIndustryArray = [String]()
    var mainIndustryIdArray = [Int]()

    @IBOutlet var tblEmployer: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        tblEmployer.backgroundColor = backGroundColor
        PickerView()
        imagePicker.delegate = self
        getIndustryApi()
        if updateScreen == true
        {
            setUpUpdateScreen()
        }
        btnNext.addTarget(self, action: #selector(btnCreateAct), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    func presentCropViewController(image : UIImage)
    {
        let cropViewController = CropViewController(croppingStyle: .circular, image: image)
        cropViewController.delegate = self
        self.present(cropViewController, animated: true, completion: nil)
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: {
            
            self.uploadImage(paramName: "file", fileName: "Profile.png", image: image.convert(toSize:CGSize(width:100.0, height:100.0), scale: UIScreen.main.scale))
        })

    }
                                   
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: {
                self.startAnimation = false

                })
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
                  Toast.show(message:"Erro", controller: self)
                    }

                }
                
            }

            }
        }
    }

    func setUpUpdateScreen()
    {
        lblMain.isHidden = true
        topLbl.constant = 10
        dictTable.remove(at: 0)
        btnNext.isHidden = true
        industryId = ((dataJson["data"] as! NSDictionary)["industryId"] as? Int) ?? 0
        self.dictTable[0]["value"] = ((dataJson["data"] as! NSDictionary)["companyName"] as? String) ?? ""
        self.dictTable[1]["value"] = ((dataJson["data"] as! NSDictionary)["industry"] as? String) ?? ""
        self.dictTable[2]["value"] = ((dataJson["data"] as! NSDictionary)["webSite"] as? String) ?? ""
        self.dictTable[3]["value"] = String(describing: ((dataJson["data"] as! NSDictionary)["linkedInProfile"] as AnyObject))
        self.dictTable[4]["value"] = converrDateFormat(string: (((dataJson["data"] as! NSDictionary)["foundationDate"] as? String)) ?? "",monthFormat: true)
        self.dictTable[5]["value"] = ((dataJson["data"] as! NSDictionary)["companyLocation"] as? String) ?? ""
        if let size = ((dataJson["data"] as! NSDictionary)["companySize"] as? Int)
        {
            if size > 4
            {
                self.dictTable[6]["value"] = String(describing: size)
            }
            else
            {
                self.dictTable[6]["value"]  = companyArray[size]
            }

        }
        else
        {
            self.dictTable[6]["value"] = companyArray[0]

        }
        
    }

    func updateEmployerProfileData() -> [String : Any]
    {
       return [
        "companyLogo":companyLogoUrl,
        "userType": 1,
        "companyName": dictTable[1]["value"]!,
        "industryId": industryId,
        "industry":dictTable[2]["value"]!,
        "webSite": dictTable[3]["value"]!,
        "linkedInProfile": dictTable[4]["value"]!,
        "foundationDate": dictTable[5]["value"]! == "" ? nil : dictTable[5]["value"]!,
        "companyLocation" : dictTable[6]["value"]!,
        "companySize": CompanySize(rawValue: dictTable[7]["value"]!)?.id ?? 0
        // int company size
        ] as [String : Any]
    }
    
    func updateEmployer() -> [String : Any]
    {
       return [
        "userType": 1,
        "companyName": dictTable[0]["value"]!,
        "industry":dictTable[1]["value"]!,
        "industryId": industryId,
        "webSite": dictTable[2]["value"]!,
        "linkedInProfile": dictTable[3]["value"]!,
        "foundationDate": dictTable[4]["value"]! == "" ? nil : dictTable[4]["value"]!,
        "companyLocation" : dictTable[5]["value"]!,
        "companySize": CompanySize(rawValue: dictTable[6]["value"]!)?.id ?? 0
        // int company size
        ] as [String : Any]
    }
    func updateEmployerProfileApi()
    {
        ApiManager().postRequest(parameters: updateScreen == true ? updateEmployer() :  updateEmployerProfileData(),api:  ApiManager.shared.UpdateEmployerProfile) { dataJson, error in
            if let error = error
            {
                DispatchQueue.main.async {
                    Toast.show(message:error.localizedDescription, controller: self)

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
                      if self.updateScreen == false
                      {
                          UserDefaults.standard.set(1, forKey: "userType")
                          let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddNewJobAndVideoVC") as! AddNewJobAndVideoVC
                          vc.fromEmployerScreen = true
                          self.navigationController?.pushViewController(vc, animated: true)
                      }
                      else
                      {
                          self.navigationController?.popViewController(animated: true)
                      }
                      
                  }
                }
                else
                {
                  
                        DispatchQueue.main.async {
                            Toast.show(message:(dataJson["title"] as? String) ?? errorMessage , controller: self)

                            //  Toast.show(message:(dataJson["errors"] as! [NSDictionary])[0], controller: self)
                        }
                    

                }
                
            }

            }
        }
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
    @objc private func showDatePicker() {
          let minDate = MonthYear()
          minDate.year -= 100
        minDate.month -= 100
          let maxDate = MonthYear()
          maxDate.year += 100
        minDate.month += 100

          MonthYearPickerViewController.present(vc: self, minDate: minDate, maxDate: maxDate, selectedDate: selectedDate, onDateSelected: onDateSelected)
      }
      
      private func onDateSelected(month: Int, year: Int) {
          selectedDate = MonthYear(month: month, year: year)
          dictTable[textFieldTag]["value"] = formatMonthYear(date: selectedDate)
          tblEmployer.reloadData()
      }
      
      private func formatMonthYear(date: MonthYear) -> String {
          return date.month < 10 ? "0\(date.month)-\(date.year)" : "\(date.month)-\(date.year)"
      }
    
//    func showDatePicker(){
//      //Formate Date
//        //ToolBar
//        toolbar.barStyle = .default
//        toolbar.isTranslucent = true
//        toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
//        toolbar.sizeToFit()
//
//     let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
//        doneButton.tintColor = UIColor.black
//
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//    let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
//        cancelButton.tintColor = UIColor.black
//
//   toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
//   }

   

   @objc func cancelDatePicker(){
      self.view.endEditing(true)
    }
    @objc func doneClick() {
        dictTable[textFieldTag]["value"] = pickerArray[index]
        pickerViewTf.resignFirstResponder()
     }
    @objc func cancelClick() {
        pickerViewTf.resignFirstResponder()
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
           //     imagePicker.allowsEditing = true
                imagePicker.cameraDevice = .front
                self.present(imagePicker, animated: true, completion: nil)
            }
            else
            {
                let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }

        func openGallary()
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
}

extension EmployerVC
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictTable.count
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 110))
        view.backgroundColor = backGroundColor
        let button = UIButton(frame: CGRect(x: 20, y: 40, width: self.view.frame.width - 40, height: 50))
        button.layer.cornerRadius = 10
        button.setTitle(updateScreen == false ? "Create" : "Update", for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(btnCreateAct), for: .touchUpInside)
        button.backgroundColor = blueButtonColor
        view.addSubview(button)
        return view
    }
    @objc func btnEditImageAct(_ sender : UIButton)
    {
        cameraGallery()
    }
    @objc func btnCreateAct()
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
        updateEmployerProfileApi()
    }
    
    @objc func btnShowNumberPicker(_ sender : UIButton)
    {
        let alert = UIAlertController(title: "", message: "Select Country Code", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "United States", style: .default, handler: { action in
            self.countryCode = "USA"
            self.tblEmployer.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Ukraine", style: .default, handler: { action in
            self.countryCode = "Ukraine"
            self.tblEmployer.reloadData()

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
         if (dictTable[indexPath.row]["title"]!) == "Upload Company Logo"
        {
             let identifier = "LogoViewCell"
             tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
             let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! LogoViewCell
             cell.imgMain.image = companyImage
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
        cell.btnPlus.isHidden = true
        if (dictTable[indexPath.row]["required"]!) == "true"
        {
            
            let attributedMark = NSMutableAttributedString(
                string: "*",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
            )
            attributedString.append(attributedMark)

            cell.tfMain.attributedPlaceholder = attributedString
        }
        if (dictTable[indexPath.row]["title"]!) == "Company Foundation Date"
        {
            cell.imgVector.image = UIImage(imageLiteralResourceName: "Frame")
            cell.heightImg.constant = 25
            cell.widthImg.constant = 25
            cell.topImage.constant = 25
        }
        else if (dictTable[indexPath.row]["title"]!) == "Upload Company Logo"
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
        if (dictTable[indexPath.row]["title"]!) == "Company Name"
        {
            cell.tfMain.text = dictTable[indexPath.row]["value"]!.capitalizingFirstLetter()

        }
        else
        {
            cell.tfMain.text = dictTable[indexPath.row]["value"]!

        }
        if (dictTable[indexPath.row]["type"]!) == "text"
        {
            cell.imgVector.isHidden = true
        }
        else
        {
            if (dictTable[indexPath.row]["title"]!) == "Company Location"
            {
                cell.imgVector.isHidden = true
            }
            else
            {
                cell.imgVector.isHidden = false
            }
        }
        if (dictTable[indexPath.row]["type"]!) == "btn"
        {
            cell.tfMain.isUserInteractionEnabled = false
        }
        else
        {
            cell.tfMain.isUserInteractionEnabled = true
        }
        if (dictTable[indexPath.row]["title"]!) == "Upload Company Logo"
        {
            cell.imgProfile.image = companyImage

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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (dictTable[indexPath.row]["type"]!) == "btn"
        {
            if (dictTable[indexPath.row]["title"]!) == "Upload Company Logo"
            {
                cameraGallery()
            }
            if (dictTable[indexPath.row]["title"]!) == "Company Foundation Date"
            {
                textFieldTag = indexPath.row
                showDatePicker()
            }
            if (dictTable[indexPath.row]["title"]!) == "Company Location"
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
                vc.searchAdressDelegate = self
                self.navigationController?.pushViewController(vc, animated: true)

            }
            if (dictTable[indexPath.row]["title"]!) == "Industry"
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

extension EmployerVC : UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        index = row
    }}
extension EmployerVC : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldTag = textField.tag
        if (dictTable[textFieldTag]["type"]!) == "drop"
        {
            if (dictTable[textFieldTag]["title"]!) == "Company Foundation Date"
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

      
        if (dictTable[textFieldTag]["title"]!) == "Current Location"
        {
            pickerArray = ["Ropar","Mansa"]
        }
        else if (dictTable[textFieldTag]["title"]!) == "Experience Level"
        {
            pickerArray = ["1 year","3 years"]
        }
        else if (dictTable[textFieldTag]["title"]!) == "Spoken Language"
        {
            pickerArray = ["Eng","Hindi"]
        }else if (dictTable[textFieldTag]["title"]!) == "Company Size"
        {
            pickerArray = ["Not Selected","1-4 workers","5 – 19 workers","20 – 99 workers","100 and more workers"]
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
        
        tblEmployer.reloadData()
    }
}
// MARK: - UIImagePickerControllerDelegate
extension EmployerVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)

        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        startAnimation = true
        DispatchQueue.main.async {
            self.tblEmployer.reloadData()

        }
        presentCropViewController(image: image)
    }
    func uploadImage(paramName: String, fileName: String, image: UIImage) {
     //   SwiftLoader.show(animated: true)
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
                        self.companyImage = image
                        self.startAnimation = false

                        DispatchQueue.main.async {
                            self.tblEmployer.reloadData()
                        }
                        self.companyLogoUrl = dict["url"] as? String ?? ""
                      //  SwiftLoader.hide()

                      
                      }
                    print(json)

                }
            //    SwiftLoader.hide()

            }
            else
            {
             //   SwiftLoader.hide()
                print(error?.localizedDescription)
            }
        }).resume()
    }


}

