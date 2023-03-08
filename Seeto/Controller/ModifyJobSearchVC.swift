//
//  ModifyJobSearchVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 07/01/23.
//

import UIKit
 
protocol SearchDetailDelegate
{
    func dataFromSearch(data : [NSDictionary] )
}
class ModifyJobSearchVC: UIViewController ,UINavigationControllerDelegate{
    var fromHome = false

    var dictTable = [["title":"Position","type":"text","value":""],["title":"Experience Level","type":"drop","value":""],["title":"Industry","type":"drop","value":""],["title":"Job Type","type":"drop","value":""],["title":"On-Site/Remote","type":"drop","value":""],["title":"Location","type":"drop","value":""],["title":"Desired Salary","type":"text","value":""]]
    var pickerArray = [""]
    
    var searchDetailDelegate : SearchDetailDelegate!
    let toolBar = UIToolbar()
    var index = 0
    var textFieldTag = 0
    var pickerViewTf = UITextField()

    @IBOutlet var tblModifySearch: UITableView!
    var myPickerView : UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        PickerView()
        // Do any additional setup after loading the view.
    }
    func addNewSearchData() -> [String : Any]
    {
       return [
            "position" : dictTable[0]["value"]!,
            "experienceLevel" : ExperienceLevel(rawValue: dictTable[1]["value"]!)?.id ?? "",
            "industry":  dictTable[2]["value"]!,
            "jobType" : JobType(rawValue: dictTable[3]["value"]!)?.id ?? "",
            "jobLocation" : JobLocation(rawValue: dictTable[4]["value"]!)?.id ?? "",
            "page" : 1,
            "pageSize" : 10,
        ] as [String : Any]
    }
    func getIndustryApi()
    {
        ApiManager().postRequest(parameters: [:],api:  ApiManager.shared.GetAllIndustries) { dataJson, error in
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
                       
                        if self.fromHome == false
                        {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyJobSearchesVC") as! MyJobSearchesVC
                            vc.arraySearch = dictArray
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else
                        {
                            self.searchDetailDelegate.dataFromSearch(data: dictArray)
                            self.navigationController?.popViewController(animated: true)
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

    func AddSearchApi()
    {
        ApiManager().postRequest(parameters: addNewSearchData(),api:  ApiManager.shared.SearchJob) { dataJson, error in
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
                       
                        if self.fromHome == false
                        {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyJobSearchesVC") as! MyJobSearchesVC
                            vc.arraySearch = dictArray
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else
                        {
                            self.searchDetailDelegate.dataFromSearch(data: dictArray)
                            self.navigationController?.popViewController(animated: true)
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
       let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ModifyJobSearchVC.doneClick))
        doneButton.tintColor = UIColor.black
       let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
       let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ModifyJobSearchVC.cancelClick))
        cancelButton.tintColor = UIColor.black

       toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
       toolBar.isUserInteractionEnabled = true
    }
    @IBAction func btnBackAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func doneClick() {
        dictTable[textFieldTag]["value"] = pickerArray[index]
     
        pickerViewTf.resignFirstResponder()
     }
    @objc func cancelClick() {
        pickerViewTf.resignFirstResponder()
    }
   
    
}
extension ModifyJobSearchVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "CandidateProfileCell"
        tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CandidateProfileCell
        cell.phoneCountryView.isHidden = true

        if (dictTable[indexPath.row]["type"]!) == "text"
        {
            cell.imgVector.isHidden = true
        }
        else
        {
            cell.imgVector.isHidden = false
        }
        cell.topImage.constant = 32
        cell.tfMain.tag = indexPath.row
        cell.tfMain.delegate = self
        cell.tfMain.text = dictTable[indexPath.row]["value"]!
        cell.tfMain.placeholder =  (dictTable[indexPath.row]["title"]!)

        cell.selectionStyle = .none
        return cell

    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        view.backgroundColor = backGroundColor
        let button = UIButton(frame: CGRect(x: 20, y: 25, width: self.view.frame.width - 60, height: 50))
        button.layer.cornerRadius = 10
        button.setTitle("Apply", for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(btnApplyAct), for: .touchUpInside)
        button.backgroundColor = blueButtonColor
        view.addSubview(button)
        return view
    }
    @objc func btnApplyAct()
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
            Toast.show(message:"Please add Industry", controller: self)
            return
        }  else if dictTable[3]["value"] == ""
        {
            Toast.show(message:"Please add Job Type", controller: self)
            return
        }  else if dictTable[4]["value"] == ""
        {
            Toast.show(message:"Please add On-Site/Remote", controller: self)
            return
        }
        AddSearchApi()
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
}
extension ModifyJobSearchVC : UIPickerViewDelegate, UIPickerViewDataSource
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
extension ModifyJobSearchVC : UITextFieldDelegate
{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldTag = textField.tag
        if (dictTable[textFieldTag]["type"]!) == "drop"
        {
      
        if (dictTable[textFieldTag]["title"]!) == "Experience Level"
        {

            DispatchQueue.main.async { [self] in
                pickerArray = ExperienceLevel.allCases.map { $0.rawValue }

            }
        }
        else if (dictTable[textFieldTag]["title"]!) == "Job Type"
        {
            DispatchQueue.main.async { [self] in
                
                pickerArray = JobType.allCases.map { $0.rawValue }
            }
        }
        else if (dictTable[textFieldTag]["title"]!) == "On-Site/Remote"
        {
            DispatchQueue.main.async { [self] in
                
                pickerArray = JobLocation.allCases.map { $0.rawValue }
            }
        }else if (dictTable[textFieldTag]["title"]!) == "Location"
        {
            DispatchQueue.main.async { [self] in
                
                pickerArray = ["Mohali","Noida"]
            }
        }
            else if (dictTable[textFieldTag]["title"]!) == "Industry"
            {
                DispatchQueue.main.async { [self] in
                    
                    pickerArray = ["Intel","Mechanical"]
                }
            }
            pickerViewTf = textField
            textField.inputView = myPickerView
            textField.inputAccessoryView = toolBar
            index = 0
            self.myPickerView.selectRow(0, inComponent: 0, animated: false)

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
            if (dictTable[textFieldTag]["type"]!) == "text"
            {
                (dictTable[textFieldTag]["value"]) = updatedText
            }
            
        }
           
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        tblModifySearch.reloadData()
    }
}
