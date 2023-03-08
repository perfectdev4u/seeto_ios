//
//  ProfileSettingView.swift
//  Seeto
//
//  Created by Paramveer Singh on 10/01/23.
//

import UIKit
import SDWebImage
import AVKit
import MobileCoreServices
import SwiftLoader
class ProfileSettingView: UIViewController, UINavigationControllerDelegate {
    var dictTable = [["title":"Name","value":"Loading..."],["title":"DOB","value":"Loading..."],["title":"Linkedin Profile","value":"Loading..."],["title":"Gender","value":"Loading..."],["title":"Current Location","value":"Loading..."],["title":"Current Position","value":"Loading..."],["title":"Experience Level","value":"Loading..."],["title":"Spoken Language","value":"Loading..."]]
    var mainDataJson = NSDictionary.init()
    var urlVideo = URL(string: "")
    var videoUrlString = ""
    var langList = [NSDictionary].init()
    var langArray = [] as! [String]

    let imagePicker = UIImagePickerController()

    @IBOutlet var tblProfileSettings: UITableView!
    var profileUrl = ""
    var firstTime = true
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getCandidateProfileApi()
    }
    
    @objc func updateCandidateProfileApi()
    {
        ApiManager().postRequest(parameters: updateCandidateDict(),api:  ApiManager.shared.UpdateCandidateProfile) { dataJson, error in
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
                if let dict = dataJson["data"] as? NSDictionary{
                  }
                  print(dataJson)
                  DispatchQueue.main.async {
                      self.showToast(message: "Sucessfully Updated")
                      self.getCandidateProfileApi()
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
    
    func updateCandidateDict() -> [String : Any]
    {
        
       return [
            "userType" : 2,
            "firstName" : ((mainDataJson["data"] as! NSDictionary)["firstName"] as! String),
            "lastName" : ((mainDataJson["data"] as! NSDictionary)["lastName"] as! String),
            "dateOfBirth" : ((mainDataJson["data"] as! NSDictionary)["dateOfBirth"] as! String),
            "linkedInProfile" : ((mainDataJson["data"] as! NSDictionary)["linkedInProfile"] as! String),
            "experienceLevel" :  ((mainDataJson["data"] as! NSDictionary)["experienceLevel"] as! Int),
            "desiredMonthlyIncome" : ((mainDataJson["data"] as! NSDictionary)["desiredMonthlyIncome"] as! Int),
            "education" : ((mainDataJson["data"] as! NSDictionary)["education"] as! String),
            "workExperience" :((mainDataJson["data"] as! NSDictionary)["workExperience"] as! String),
            "gender" : ((mainDataJson["data"] as! NSDictionary)["gender"] as! Int),
            "disability" : ((mainDataJson["data"] as! NSDictionary)["disability"] as! String),
            "veteranStatus" : ((mainDataJson["data"] as! NSDictionary)["veteranStatus"] as! String),
            "country" : "America",
            "region" : "California",
            "city" : "Cali",
            "currentLocation" : ((mainDataJson["data"] as! NSDictionary)["currentLocation"] as! String),
            "latitude" : 0,
            "longitude" : 0,
            "currentPosition" : ((mainDataJson["data"] as! NSDictionary)["currentPosition"] as! String),
            "jobType" : 0,
            "bio" :"",
            "videoUrl": videoUrlString,
            "profileImage" : profileUrl,
            "languageList" : ((mainDataJson["data"] as! NSDictionary)["languageList"] as! [NSDictionary])

        ] as [String : Any]
    }


    func getCandidateProfileApi()
    {
        ApiManager().getRequest(api: ApiManager.shared.GetCandidateProfile,showLoader: firstTime) { dataJson, error in
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
                  DispatchQueue.main.async {
         print(dataJson)
                      self.mainDataJson = dataJson as NSDictionary
                      self.dictTable[0]["value"] = ((dataJson["data"] as! NSDictionary)["firstName"] as! String) + " " +  ((dataJson["data"] as! NSDictionary)["lastName"] as! String)
                      self.dictTable[1]["value"] = ((dataJson["data"] as! NSDictionary)["dateOfBirth"] as! String)
                      self.dictTable[2]["value"] = ((dataJson["data"] as! NSDictionary)["linkedInProfile"] as! String)
                      self.dictTable[3]["value"] = String(describing: ((dataJson["data"] as! NSDictionary)["gender"] as AnyObject)) == "1" ? "Male" : "Female"
                      self.dictTable[4]["value"] = ((dataJson["data"] as! NSDictionary)["currentLocation"] as! String)
                      self.dictTable[5]["value"] = ((dataJson["data"] as! NSDictionary)["currentPosition"] as! String)
                      self.dictTable[6]["value"] = experienceArray[((dataJson["data"] as! NSDictionary)["experienceLevel"] as? Int) ?? 0]
                     // = ((dataJson["data"] as! NSDictionary)["languageList"] as! String)
                      self.profileUrl = ((dataJson["data"] as! NSDictionary)["profileImage"] as! String)
                      self.videoUrlString = ((dataJson["data"] as! NSDictionary)["videoUrl"] as! String)
                      self.dictTable[7]["value"] = ""
                      for i in ((dataJson["data"] as! NSDictionary)["languageList"] as! [NSDictionary])
                      {
                          
                          self.dictTable[7]["value"]?.append((i["language"] as! String) + " ")
                      }
                      self.tblProfileSettings.reloadData()
                    //  self.showToast(message: ()
                  }
                }
                else
                {
                    DispatchQueue.main.async {

                      //  self.showToast(message: ()
                        Toast.show(message:(dataJson["returnMessage"] as? [String])?[0] ?? "Error Occured", controller: self)
                    }

                }
                
            }

            }
        }
        firstTime = false

    }


    @IBAction func btnBackAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func cameraGallery()
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


  @objc func openCamera()
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
extension ProfileSettingView : UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 :  dictTable.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        if indexPath.section == 0
        {
            
            let identifier = "ProfileViewCell"
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ProfileViewCell
            cell.selectionStyle = .none
            cell.lblName.text = self.dictTable[0]["value"]
            if self.dictTable[0]["value"] != "Loading..."
            {
                cell.imgVideo.layer.cornerRadius = cell.imgVideo.frame.height / 2
                cell.imgVideo.sd_setImage(with: URL(string: ((mainDataJson["data"] as! NSDictionary)["profileImage"] as! String)), placeholderImage: UIImage(named: "placeholderImg"))

            }
            cell.btnImageProfilr.addTarget(self, action: #selector(cameraGallery), for: .touchUpInside)

            
            return cell

        }
            if indexPath.row == 0
            {
                let identifier = "DetailsCell"
                tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! DetailsCell
                cell.imgDown.isHidden = false
                cell.imgDown.image = UIImage(named: "edit")
                cell.heightImage.constant = 23
                cell.widthImage.constant = 23
                cell.lblDetails.text = "Profile Details"
                cell.trailingImg.constant = 18
                cell.btnEdit.addTarget(self, action: #selector(btnActEdit), for: .touchUpInside)
                cell.selectionStyle = .none
                return cell
            }
            else
            {
                let identifier = "MyJobDetailCell"
                tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MyJobDetailCell
                cell.myJobTitleLbl.text = (dictTable[indexPath.row - 1]["title"] ?? "")
                cell.mainView.backgroundColor = darkShadeColor
                cell.leadingMainView.constant = 20
                cell.trailingMainView.constant = 20
                if (dictTable[indexPath.row - 1]["title"] ?? "") ==  "Linkedin Profile"
                {
                    cell.myJobDataLbl.textColor = blueButtonColor
                    let underlineAttriString = NSAttributedString(string: dictTable[indexPath.row - 1]["value"]!,
                                                              attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
                    cell.myJobDataLbl.attributedText = underlineAttriString
                    cell.myJobDataLbl.isUserInteractionEnabled = true
                    cell.myJobDataLbl.tag = indexPath.row
                    let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
                    tapgesture.numberOfTapsRequired = 1
                    cell.myJobDataLbl.addGestureRecognizer(tapgesture)

                }
                else
                {
                    let AttriString = NSAttributedString(string: dictTable[indexPath.row - 1]["value"]!)
                    cell.myJobDataLbl.attributedText = AttriString
                    cell.myJobDataLbl.textColor = UIColor.white
                }
                if indexPath.row == (tableView.numberOfRows(inSection: 0) - 1)
                {
                    cell.mainView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10.0)
                    cell.seperaterView.isHidden = true
                }
                else
                {
                    cell.seperaterView.isHidden = false
                }
                cell.selectionStyle = .none
                return cell
                
            }

        }

    @objc func btnCreateVideoAct()
    {
       
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
    @objc func btnResumePreview()
    {
       
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResumeVideoPreviewVC") as! ResumeVideoPreviewVC
            vc.urlVideo = URL(string: videoUrlString)
            self.navigationController?.pushViewController(vc, animated: true)
 }
      
    
    
    @objc func btnActEdit()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CandidateProfileVC") as! CandidateProfileVC
        vc.updateScreen = true
        vc.dataJson = mainDataJson
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    //MARK:- tappedOnLabel
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        var link = dictTable[gesture.view!.tag - 1]["value"]!
        if !link.contains("https://")
        {
            link = "https://" + dictTable[gesture.view!.tag - 1]["value"]!
        }
        guard let url = URL(string: link ) else { return }
        UIApplication.shared.open(url)

    }
   
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height:section == 1 ? 80 : .leastNormalMagnitude))
        if section == 1
        {
            view.backgroundColor = backGroundColor
            let button = UIButton(frame: CGRect(x: 20, y: 20, width: self.view.frame.width - 40, height: 50))
            button.layer.cornerRadius = 10
            button.setTitle("      Resume Video Preview", for: .normal)
            button.setTitleColor(blueButtonColor, for: .normal)
            button.titleLabel?.font =  UIFont.systemFont(ofSize: 14, weight: .light)
            button.backgroundColor = darkShadeColor
            button.contentHorizontalAlignment = .left
            let buttonEdit = UIButton(frame: CGRect(x:  self.view.frame.width - 65, y: 30, width: 30, height: 30))
            buttonEdit.setImage(UIImage(named: "edit"), for: .normal)
            button.addTarget(self, action: #selector(btnResumePreview), for: .touchUpInside)
            buttonEdit.addTarget(self, action: #selector(btnCreateVideoAct), for: .touchUpInside)

            
            view.addSubview(button)
            view.addSubview(buttonEdit)
        }
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? .leastNormalMagnitude : 80
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
        view.backgroundColor = .clear
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

extension ProfileSettingView: UIImagePickerControllerDelegate {
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
                             print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
                              self.uploadVideo(paramName: "file", fileName: "ProfileVideo.mp4", dataVideo: compressedData as Data,url: compressedURL)

                          case .failed:
                              break
                          case .cancelled:
                              break
                          }
                      }
                 
                  
        // Handle a movie capture
      
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
    func uploadVideo(paramName: String, fileName: String, dataVideo: Data,url : URL) {
        DispatchQueue.main.async {
            SwiftLoader.show(animated: true)
        }

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
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .mutableContainers)
                if let json = jsonData as? [String: Any] {
                    if let dict = json["data"] as? NSDictionary{
                        DispatchQueue.main.async {
                            SwiftLoader.hide()
                        }

                        self.videoUrlString = (dict["url"] as? String) ?? ""
                        DispatchQueue.main.async {
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
        }).resume()
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
                        self.profileUrl = (dict["url"] as? String) ?? ""
                        DispatchQueue.main.async {
                            SwiftLoader.hide()
                            self.updateCandidateProfileApi()
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
          vc.dictParam = self.updateCandidateDict()
          vc.updateVideo = true
          self.navigationController?.pushViewController(vc, animated: true)
      }
                                   ))
      present(alert, animated: true, completion: nil)
  }
}

