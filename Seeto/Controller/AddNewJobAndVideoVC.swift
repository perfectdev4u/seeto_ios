//
//  AddNewJobAndVideoVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 27/01/23.
//

import UIKit
import AVKit
import MobileCoreServices
import SwiftLoader
import GrowingTextView

class AddNewJobAndVideoVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate,JobDelegate, SearchAddressProtocol, MinMaxSalaryDelegate, UITextViewDelegate {
    @IBOutlet var lblAddNewJob: UILabel!
    var heightTxtV = 40.0
    var mainMinSal = 0
    var mainMaxSal = 0
    @IBOutlet var btnBack: UIButton!
    var fromEmployerScreen = false
    func addMinMaxSalary(minSal: String, maxSal: String) {
        for i in 0...dictTable.count - 1
        {
            if dictTable[i]["title"] == "Salary Range in U.S. Dollars"
            {
                mainMinSal = Int(minSal)!
                mainMaxSal = Int(maxSal)!

                dictTable[i]["value"] = minSal + " - " + maxSal
            }
        }
        DispatchQueue.main.async {
            self.tblJob.reloadData()
        }
    }
    
    func adressMap(address: String) {
        for i in 0...dictTable.count - 1
        {
            if dictTable[i]["title"] == "Location"
            {
                dictTable[i]["value"] = address
            }
        }
        DispatchQueue.main.async {
            self.tblJob.reloadData()
        }
    }
    
    func JobDone() {
        if fromHome == false
        {
            jobDelegate.JobDone()
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        else
        {
          
                
                var param = [
                    "jobId":  jobId,
                ] as [String : Any]
                
                ApiManager().postRequest(parameters: param,api:  ApiManager.shared.GetAllCandidateByJob) { dataJson, error in
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
                                if dictArray.count == 0
                                {
                                    Toast.show(message: "No match found for your job", controller: self)

                                }
                                else
                                {
                                    self.searchDetailDelegate.dataFromSearch(data: dictArray, searchId: String(self.jobId) )
                                    DispatchQueue.main.async {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                    
                                }
                            }
                          }
                        }
                        else
                        {
                            DispatchQueue.main.async {

                              //  self.showToast(message: ()
                          Toast.show(message:errorMessage, controller: self)
                            }

                        }
                        
                    }

                    }
                
            }

        }
     
        
    }
    var task = URLSessionDataTask.init()
    var searchDetailDelegate : SearchDetailDelegate!
    var jobId = -1
    var sizeItem = CGFloat.init()
    var fromHome = false
    var jobDelegate : JobDelegate!
    var videoUrlString = ""
    @IBOutlet var tblJob: UITableView!
    let imagePicker = UIImagePickerController()
    @IBOutlet var btnNext: UIButton!
    var urlVideo = URL(string: "")
    var dictTable = [["title":"Position","type":"text","required":"true","value":""],["title":"Experience Level","type":"drop","required":"true","value":""],["title":"Job Type","type":"drop","required":"true","value":""],["title":"On-Site/Remote","type":"drop","required":"true","value":""],["title":"Location","type":"btn","required":"false","value":""],["title":"Salary Range in U.S. Dollars","type":"btn","required":"false","value":""],["title":"Job Description","type":"text","required":"true","value":""]]
    var myPickerView : UIPickerView!
    var pickerArray = ["USA","UKR"]
    let toolBar = UIToolbar()
    var index = 0
    var pickerViewTf = UITextField()
    var pickerString = ""
    var textFieldTag = 0
    let toolbar = UIToolbar();
    var countryCode = "USA"
    var jobsDelegate : JobDelegate!
    var inputArray = NSDictionary.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        PickerView()
        tblJob.backgroundColor = backGroundColor
        imagePicker.delegate = self
        btnNext.addTarget(self, action: #selector(btnCreateVideoAct), for: .touchUpInside)
        automaticallyAdjustsScrollViewInsets = false
         if fromHome == true
        {
             self.dictTable[0]["value"]! = self.inputArray["position"] as? String ?? ""
             self.dictTable[1]["value"]! = experienceArray[self.inputArray["experienceLevel"] as? Int ?? 0]
             self.dictTable[2]["value"]! = jobArray[self.inputArray["jobType"] as? Int ?? 0]
             self.dictTable[3]["value"]! = JobLocationArray[self.inputArray["jobLocation"] as? Int ?? 0]
             self.dictTable[4]["value"]! = self.inputArray["location"] as? String ?? ""
             self.dictTable[6]["value"]! = self.inputArray["jobDescription"] as? String ?? ""
             for i in 0...dictTable.count - 1
             {
                 if dictTable[i]["title"] == "Salary Range in U.S. Dollars"
                 {
                     if String(describing: self.inputArray["maxSalary"] as AnyObject) != "0" && self.inputArray["maxSalary"] != nil
                     {
                         dictTable[i]["value"] = String(describing: self.inputArray["minSalary"] as AnyObject) + " - " + String(describing: self.inputArray["maxSalary"] as AnyObject)
                     }
                 }
             }
             mainMaxSal = self.inputArray["maxSalary"] as? Int ?? 0
             mainMinSal = self.inputArray["minSalary"] as? Int ?? 0

             lblAddNewJob.text = "Update Job"
//             btnNext.setTitle("Update", for: .normal)
            
        }
        if fromEmployerScreen == true
        {
            btnBack.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
    
    func addNewJobData() -> [String : Any]
    {
       return [
            "position" : dictTable[0]["value"]!,
            "experienceLevel" : ExperienceLevel(rawValue: dictTable[1]["value"]!)?.id ?? "",
            "jobType" : JobType(rawValue: dictTable[2]["value"]!)?.id ?? "",
            "jobLocation" : JobLocation(rawValue: dictTable[3]["value"]!)?.id ?? "",
            "location" : dictTable[4]["value"]!,
            "minSalary" : mainMinSal,
            "maxSalary" :  mainMaxSal,
            "isSalaryDisplayed" : true,
            "jobDescription" : dictTable[6]["value"]!,
            "country" : "America",
            "region" : "California",
            "city" : "Cali",
            "latitude" : 0,
            "longitude" : 0,
            "videoUrl": videoUrlString,
        ] as [String : Any]
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
        
        let alert = UIAlertController(title: "Choose", message: nil, preferredStyle: .actionSheet)
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
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                       print("Camera Available")

                       imagePicker.sourceType = .camera
                       imagePicker.mediaTypes = [kUTTypeMovie as String]
                       imagePicker.allowsEditing = false
                       imagePicker.videoQuality = .typeIFrame1280x720
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
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.mediaTypes = ["public.movie"]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    
    func updateJobApi()
    {
    
        var dictParam = self.addNewJobData()
        if self.fromHome == true
        {
            dictParam["jobId"] = jobId
        }
       
        ApiManager().postRequest(parameters: dictParam,api: ApiManager.shared.UpdateJob  ) { dataJson, error in
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
               
                  print(dataJson)
//                  UserDefaults.standard.set(2, forKey: "userType")
                  DispatchQueue.main.async {

                     
                              self.GetAllCandidateByJobApi()
                            
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
    

    func GetAllCandidateByJobApi()
    {
        
        var param = [
            "jobId":  jobId,
        ] as [String : Any]
        
        ApiManager().postRequest(parameters: param,api:  ApiManager.shared.GetAllCandidateByJob) { dataJson, error in
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
                        if dictArray.count == 0
                        {
                            Toast.show(message: "No match found for your job", controller: self)

                        }
                        else
                        {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
                            vc.mainDataArray = dictArray
                            vc.inputArray = self.addNewJobData() as NSDictionary
                            vc.searchJobId = String(describing: self.jobId)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                  }
                }
                else
                {
                    DispatchQueue.main.async {

                      //  self.showToast(message: ()
                  Toast.show(message:errorMessage, controller: self)
                    }

                }
                
            }

            }
        }
    }

}


extension AddNewJobAndVideoVC
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictTable.count
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 110))
        view.backgroundColor = backGroundColor
        let button = UIButton(frame: CGRect(x: 20, y: 40, width: self.view.frame.width - 40, height: 50))
        button.layer.cornerRadius = 10
        button.setTitle( fromHome == true ? "Update" : "Create & Record Video", for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(btnCreateVideoAct), for: .touchUpInside)
        button.backgroundColor = blueButtonColor
        view.addSubview(button)
        return view
    }
    
    @objc func btnCreateVideoAct()
    {
        
        if dictTable[0]["value"] == ""
        {
            Toast.show(message:"Please add Position", controller: self)
            return
        }
        else if dictTable[1]["value"] == ""
        {
            Toast.show(message:"Please add Experience Level", controller: self)
            return
        }
         else if dictTable[2]["value"] == ""
        {
            Toast.show(message:"Please add Job Type", controller: self)
            return
        }  else if dictTable[3]["value"] == ""
        {
            Toast.show(message:"Please add On-Site/Remote", controller: self)
            return
        }
        else if dictTable[6]["value"] == ""
        {
            Toast.show(message:"Please add Job Description", controller: self)
            return
        }
        
        if fromHome == true
        {
            updateJobApi()
            return
        }
        cameraGallery()
   

        
    }
    
    @objc func btnShowNumberPicker(_ sender : UIButton)
    {
        let alert = UIAlertController(title: "", message: "Select Country Code", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "United States", style: .default, handler: { action in
            self.countryCode = "USA"
            self.tblJob.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Ukraine", style: .default, handler: { action in
            self.countryCode = "Ukraine"
            self.tblJob.reloadData()

        }))
        self.present(alert, animated: true, completion: nil)
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
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1
//        {
//            return heightTxtV + 41
//        }// Add some padding for aesthetics
//       // CGFloat(indexPath.row == tableView.numberOfRows(inSection: 0) - 1 ? CGFloat(41 + heightTxtV) :
//        return UITableView.automaticDimension
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1
        {
            let identifier = "TextViewCell"
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TextViewCell
            let attributedString = NSMutableAttributedString(
                string: (dictTable[indexPath.row]["title"]!),
                attributes: [NSAttributedString.Key.foregroundColor: grayColor,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]
            )
            let attributedMark = NSMutableAttributedString(
                string: "*",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.red,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]
            )
            attributedString.append(attributedMark)
            if (dictTable[indexPath.row]["value"]!) == ""
            {
                cell.textView.attributedText = attributedString

            }
            else
            {
                cell.textView.text = (dictTable[indexPath.row]["value"]!)
                cell.textView.textColor = .white
            }
//            cell.textView.attributedPlaceholder = attributedString
            cell.textView.delegate = self
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
        cell.tfMain.attributedPlaceholder = attributedString
        cell.tfMain.text = (dictTable[indexPath.row]["value"]!)
        if (dictTable[indexPath.row]["type"]!) == "text" || (dictTable[indexPath.row]["type"]!) == "btn"
        {
            cell.imgVector.isHidden = true
        }
        else
        {
            cell.imgVector.isHidden = false
        }
        if  (dictTable[indexPath.row]["type"]!) == "btn"
        {
            cell.tfMain.isUserInteractionEnabled = false
        }
        else
        {
            cell.tfMain.isUserInteractionEnabled = true
        }
        
        cell.leadingTf.constant = 27
        cell.phoneCountryView.isHidden = true

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
            if (dictTable[indexPath.row]["title"]!) == "Location"
             {
                  let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
                  vc.searchAdressDelegate = self
                  self.navigationController?.pushViewController(vc, animated: true)
              }
            if (dictTable[indexPath.row]["title"]!) == "Salary Range in U.S. Dollars"
             {
                  let vc = self.storyboard?.instantiateViewController(withIdentifier: "MinMaxSalaryVC") as! MinMaxSalaryVC
                  vc.minMaxSalDelegate = self
                vc.minSal = mainMinSal
                vc.maxSal = mainMaxSal
                self.present(vc, animated: true)
              }
        }
        
    }
}

extension AddNewJobAndVideoVC : UIPickerViewDelegate, UIPickerViewDataSource
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
extension AddNewJobAndVideoVC : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldTag = textField.tag
        
        if (dictTable[textFieldTag]["type"]!) == "drop"
        {

      
        if (dictTable[textFieldTag]["title"]!) == "Experience Level"
        {
                pickerArray = ["Not Selected","Entry Level","Internship","Associate","Mid Senior","Director","Executive"]

    }
        else if (dictTable[textFieldTag]["title"]!) == "Job Type"
        {
                
                pickerArray = ["Not Selected","Full Time","Part Time","Contract","Temporary","Volunteer","Internship","Other"]
                   }
        else if (dictTable[textFieldTag]["title"]!) == "On-Site/Remote"
        {
                
                pickerArray = ["Not Selected","On-Site","Remote","Hybrid"]
            
            
        }
            else if (dictTable[textFieldTag]["title"]!) == "Location"
        {
                    
                    pickerArray = ["Mohali","Noida"]
                
        }
            else if (dictTable[textFieldTag]["title"]!) == "Salary Range in U.S. Dollars"
            {
                    
                    pickerArray = ["50000 - 100000","100000 - 200000"]
                
            }
            pickerViewTf = textField
            textField.inputView = myPickerView
            textField.inputAccessoryView = toolBar
            index = 0
            myPickerView.reloadAllComponents()
            self.myPickerView.selectRow(0, inComponent: 0, animated: false)


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
        DispatchQueue.main.async {
            self.tblJob.reloadData()
        }
    }
}
// MARK: - UIImagePickerControllerDelegate
extension AddNewJobAndVideoVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)

        guard
            let mediaType = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaType.rawValue) ] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaURL.rawValue) ] as? URL,
            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
            else {
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
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
          let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddJobVideo") as! AddJobVideo
          vc.urlVideo = self.urlVideo
          vc.dictParam = self.addNewJobData()
          vc.jobDelegate = self
          vc.jobId = jobId
          vc.fromHome = fromHome
          self.navigationController?.pushViewController(vc, animated: true)

          
  }
}

extension AddNewJobAndVideoVC
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        for i in 0...dictTable.count - 1
        {
            if dictTable[i]["title"] == "Job Description" && dictTable[i]["value"] == ""
            {
                textView.text = ""
                textView.textColor = .white
            }
        }
      
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let text = textView.text
                 
            for i in 0...dictTable.count - 1
            {
                if dictTable[i]["title"] == "Job Description"
                {
                    dictTable[i]["value"] = text
                }
            }
        self.tblJob.beginUpdates()
        self.tblJob.endUpdates()

        return true

    }
   

    func textViewDidEndEditing(_ textView: UITextView) {
        for i in 0...dictTable.count - 1
        {
            if dictTable[i]["title"] == "Job Description"
            {
                dictTable[i]["value"] = textView.text
            }
        }
        DispatchQueue.main.async
        {
            self.tblJob.reloadData()
        }
    }
}


