//
//  EmployerProfileSettingVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 25/01/23.
//

import UIKit
import SwiftLoader

class EmployerProfileSettingVC: UIViewController, UINavigationControllerDelegate {
   var companyLogoUrl = ""
    
    var dictTable = [["title":"Company name","value":"Loading..."],["title":"Industry","value":"Loading..."],["title":"Website","value":"Loading..."],["title":"Linkedin Profile","value":"Loading..."],["title":"Company Foundation Date","value":"Loading..."],["title":"Company Size","value":"Loading..."]]
    var mainDataJson = NSDictionary.init()
    let imagePicker = UIImagePickerController()

    @IBOutlet var tblProfileSettings: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getEmployerProfileApi()

    }
    
    func getEmployerProfileApi()
    {
        
        ApiManager().getRequest(api: ApiManager.shared.GetEmployerProfile,showLoader: true) { dataJson, error in
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
//                      let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppCategoryVC") as! AppCategoryVC
//                      self.navigationController?.pushViewController(vc, animated: true)
         print(dataJson)
                      self.mainDataJson = dataJson as NSDictionary
                      self.companyLogoUrl = (dataJson["data"] as! NSDictionary)["companyLogo"] as? String ?? ""
                      self.dictTable[0]["value"] = ((dataJson["data"] as! NSDictionary)["companyName"] as! String)
                      self.dictTable[1]["value"] = ((dataJson["data"] as! NSDictionary)["industry"] as! String)
                      self.dictTable[2]["value"] = ((dataJson["data"] as! NSDictionary)["webSite"] as? String) ?? ""
                      self.dictTable[3]["value"] = String(describing: ((dataJson["data"] as! NSDictionary)["linkedInProfile"] as AnyObject))
                      self.dictTable[4]["value"] = converrDateFormat(string: (((dataJson["data"] as! NSDictionary)["foundationDate"] as? String)) ?? "",monthFormat: true)
                      self.dictTable[5]["value"] = companyArray[((dataJson["data"] as! NSDictionary)["companySize"] as? Int) ?? 0]
//                      self.profileUrl = ((dataJson["data"] as! NSDictionary)["profileImage"] as! String)
//                      self.videoUrlString = ((dataJson["data"] as! NSDictionary)["videoUrl"] as! String)
                      self.tblProfileSettings.reloadData()
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


    @IBAction func btnBackAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func openCamera()
         {
             if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
             {
                 imagePicker.sourceType = UIImagePickerController.SourceType.camera
          //       imagePicker.allowsEditing = true
                 
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
extension EmployerProfileSettingVC : UITableViewDelegate,UITableViewDataSource
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
            cell.lblName.text = self.dictTable[0]["value"]
            if self.dictTable[0]["value"] != "Loading..."
            {
                cell.imgVideo.layer.cornerRadius = cell.imgVideo.frame.height / 2
                cell.imgVideo.sd_setImage(with: URL(string: companyLogoUrl), placeholderImage: UIImage(named: "placeholderImg"))

            }
            cell.btnImageProfilr.addTarget(self, action: #selector(cameraGallery), for: .touchUpInside)

            cell.selectionStyle = .none
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
                if (dictTable[indexPath.row - 1]["title"] ?? "") ==  "Website" || (dictTable[indexPath.row - 1]["title"] ?? "") ==  "Linkedin Profile"
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
                    let underlineAttriString = NSAttributedString(string: dictTable[indexPath.row - 1]["value"]!
                                                             )
                    cell.myJobDataLbl.attributedText = underlineAttriString

                    cell.myJobDataLbl.textColor = UIColor.white
                }
                if indexPath.row == (tableView.numberOfRows(inSection: 1) - 1)
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
    @objc func btnActEdit()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmployerVC") as! EmployerVC
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
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: section == 1 ? 110 : 0))
        if section == 1
        {
            view.backgroundColor = backGroundColor
            let button = UIButton(frame: CGRect(x: 20, y: 40, width: self.view.frame.width - 40, height: 50))
            button.layer.cornerRadius = 10
            button.setTitle("Logout", for: .normal)
            button.titleLabel?.font =  UIFont.systemFont(ofSize: 16, weight: .semibold)
            button.addTarget(self, action: #selector(logOut), for: .touchUpInside)
            button.backgroundColor = blueButtonColor
            view.addSubview(button)
        }
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 1 ? 110 : .leastNormalMagnitude
    }
    @objc func logOut()
    {
        let refreshAlert = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
            UserDefaults.standard.removeObject(forKey: "accessToken")
            UserDefaults.standard.removeObject(forKey: "userType")
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
            let window = UIApplication.shared.windows.first
            // Embed loginVC in Navigation Controller and assign the Navigation Controller as windows root
            let nav = UINavigationController(rootViewController: loginVC!)
            window?.rootViewController = nav
        }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
        }))

        present(refreshAlert, animated: true, completion: nil)

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

extension EmployerProfileSettingVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)

            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        uploadImage(paramName: "file", fileName: "ProfileImage.png", image: image.convert(toSize:CGSize(width:100.0, height:100.0), scale: UIScreen.main.scale) )
                return
    }
    
    func updateEmployerProfileData() -> [String : Any]
    {
       return [
        "companyLogo": companyLogoUrl,
        "userType": 1,
        "companyName": dictTable[0]["value"]!,
        "industry":dictTable[1]["value"]!,
        "industryId" : ((mainDataJson["data"] as! NSDictionary)["industryId"] as? Int) ?? 0,
        "webSite": dictTable[2]["value"]!,
        "linkedInProfile": dictTable[3]["value"]!,
        "foundationDate": dictTable[4]["value"]!,
        "companyLocation" : ((mainDataJson["data"] as! NSDictionary)["companyLocation"] as! String),
        "companySize": ((mainDataJson["data"] as! NSDictionary)["companySize"] as? Int) ?? 0
        // int company size
        ] as [String : Any]
    }
    func updateEmployerProfileApi()
    {
        ApiManager().postRequest(parameters:   updateEmployerProfileData(),api:  ApiManager.shared.UpdateEmployerProfile) { dataJson, error in
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
                      self.tblProfileSettings.reloadData()
                      
                  }
                }
                else
                {
                    DispatchQueue.main.async {

                      //  self.showToast(message: ()
                //  Toast.show(message:(dataJson["returnMessage"] as! [String])[0], controller: self)
                    }

                }
                
            }

            }
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
                        self.companyLogoUrl = (dict["url"] as? String) ?? ""
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            SwiftLoader.hide()
                            self.updateEmployerProfileApi()
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
   
}

