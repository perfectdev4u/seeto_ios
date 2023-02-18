//
//  AddNewJobAndVideoVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 27/01/23.
//

import UIKit
import AVKit
import MobileCoreServices

class AddNewJobAndVideoVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate {

    @IBOutlet var tblJob: UITableView!
    let imagePicker = UIImagePickerController()
    @IBOutlet var btnNext: UIButton!
    var urlVideo = URL(string: "")
    var dictTable = [["title":"Position","type":"text","required":"false","value":""],["title":"Experience Level","type":"drop","required":"false","value":""],["title":"Job Type","type":"drop","required":"false","value":""],["title":"On-Site/Remote","type":"drop","required":"false","value":""],["title":"Location","type":"drop","required":"false","value":""],["title":"Salary Range","type":"drop","required":"false","value":""],["title":"Job Description","type":"text","required":"true","value":""]]
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
    override func viewDidLoad() {
        super.viewDidLoad()
        PickerView()
        tblJob.backgroundColor = backGroundColor
        imagePicker.delegate = self
        btnNext.addTarget(self, action: #selector(btnCreateVideoAct), for: .touchUpInside)
        // Do any additional setup after loading the view.
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
            "experienceLevel" : dictTable[1]["value"]! == "1 year" ? 1 : 2,
            "jobType" : dictTable[2]["value"]! == "IT" ? 1 : 2,
            "jobLocation" : dictTable[3]["value"]! == "Remote" ? 2 : 1,
            "location" : dictTable[4]["value"]!,
            "minSalary" : dictTable[5]["value"]! == "50000 - 100000" ? 50000 : 1000000,
            "maxSalary" :  dictTable[5]["value"]! == "50000 - 100000r" ? 1000000 : 2000000,
            "isSalaryDisplayed" : true,
            "jobDescription" : dictTable[6]["value"]!,
            "country" : "America",
            "region" : "California",
            "city" : "Cali",
            "latitude" : 0,
            "longitude" : 0,
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
                self.present(alert, animated: true, completion: nil)
            }
        }

        func openGallary()
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
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
        button.setTitle("Create & Record Video", for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(btnCreateVideoAct), for: .touchUpInside)
        button.backgroundColor = blueButtonColor
        view.addSubview(button)
        return view
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
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
//        self.navigationController?.pushViewController(vc, animated: true)

        
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
        cell.tfMain.attributedPlaceholder = attributedString
        cell.tfMain.text = (dictTable[indexPath.row]["value"]!)
        if (dictTable[indexPath.row]["type"]!) == "text"
        {
            cell.imgVector.isHidden = true
        }
        else
        {
            cell.imgVector.isHidden = false
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

      
        if (dictTable[textFieldTag]["title"]!) == "Experience Level"
        {
            pickerArray = ["1 year","2 years","> 2 years"]
        }
        else if (dictTable[textFieldTag]["title"]!) == "Job Type"
        {
            pickerArray = ["IT","HR"]
        }
        else if (dictTable[textFieldTag]["title"]!) == "On-Site/Remote"
        {
            pickerArray = ["On-Site","Remote"]
        }else if (dictTable[textFieldTag]["title"]!) == "Location"
        {
            pickerArray = ["Mohali","Noida"]
        }
            else if (dictTable[textFieldTag]["title"]!) == "Salary Range"
            {
                pickerArray = ["50000 - 100000","100000 - 200000"]
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
        
        tblJob.reloadData()
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
        // Handle a movie capture
        UISaveVideoAtPathToSavedPhotosAlbum(
            url.path,
            self,
            #selector(video(_:didFinishSavingWithError:contextInfo:)),
            nil)
    }

    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
      let title = (error == nil) ? "Success" : "Error"
      let message = (error == nil) ? "Video was saved" : "Video failed to save"

      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler:{_ in  print("Foo")
          let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddJobVideo") as! AddJobVideo
          vc.urlVideo = self.urlVideo
          vc.dictParam = self.addNewJobData()
          self.navigationController?.pushViewController(vc, animated: true)

          
      }
                                   ))
      present(alert, animated: true, completion: nil)
  }
}

