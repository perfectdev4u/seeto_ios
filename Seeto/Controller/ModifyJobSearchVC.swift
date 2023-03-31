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
class ModifyJobSearchVC: UIViewController ,UINavigationControllerDelegate, SearchAddressProtocol,SearchIndustryProtocol{
    func industryString(string: String) {
        for i in 0...dictTable.count - 1
        {
            if dictTable[i]["title"] == "Industry"
            {
                dictTable[i]["value"] = string
            }
        }
        DispatchQueue.main.async {
            self.tblModifySearch.reloadData()
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
            self.tblModifySearch.reloadData()
        }
    }
    
    var fromHome = false

    var dictTable = [["title":"Position","type":"text","value":""],["title":"Experience Level","type":"drop","value":""],["title":"Industry","type":"btn","value":""],["title":"Job Type","type":"drop","value":""],["title":"On-Site/Remote","type":"drop","value":""],["title":"Location","type":"btn","value":""],["title":"Desired Salary","type":"text","value":""]]
    var pickerArray = [""]
    var mainIndustryArray = [String]()
    var mainDataArray = [NSDictionary].init()
//    ["title":"Current Location","type":"btn","required":"false","value":""]
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
        getIndustryApi()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
    
    func AddJobSearchApi()
    {
        ApiManager().postRequest(parameters: addNewSearchData(),api:  ApiManager.shared.AddJobSearch) { dataJson, error in
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
                print(dataJson)
              if String(describing: (dataJson["statusCode"] as AnyObject)) == "200"
                {
                    DispatchQueue.main.async {
                       
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
                            vc.mainDataArray = self.mainDataArray
                            vc.searchId = (dataJson["data"] as? NSDictionary)?["searchId"] as? String ?? ""
                            self.navigationController?.pushViewController(vc, animated: true)
                        
                        
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
        ApiManager().postRequest(parameters: addNewSearchData(),api:  ApiManager.shared.SearchJobs) { dataJson, error in
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
                    self.mainDataArray = dictArray
                    if self.mainDataArray.count > 0
                    {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.AddJobSearchApi()
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async {
                        Toast.show(message:"No match found for your search", controller: self)
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

        cell.topImage.constant = 32
        cell.tfMain.tag = indexPath.row
        cell.tfMain.delegate = self
        cell.tfMain.text = dictTable[indexPath.row]["value"]!
        cell.tfMain.placeholder =  (dictTable[indexPath.row]["title"]!)

        cell.selectionStyle = .none
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (dictTable[indexPath.row]["type"]!) == "btn"
        {
           if (dictTable[indexPath.row]["title"]!) == "Location"
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
                vc.forIndustry = true
                  self.navigationController?.pushViewController(vc, animated: true)
              }
            
        }
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

                pickerArray = ["Not Selected","Entry Level","Internship","Associate","Mid Senior","Director","Executive"]

            
        }
        else if (dictTable[textFieldTag]["title"]!) == "Job Type"
        {
                
                pickerArray = ["Not Selected","Full Time","Part Time","Contract","Temporary","Volunteer","Internship","Other"]
            
        }
        else if (dictTable[textFieldTag]["title"]!) == "On-Site/Remote"
        {
                
                pickerArray = ["Not Selected","On-Site","Remote","Hybrid"]
            
        }else if (dictTable[textFieldTag]["title"]!) == "Location"
        {
                
                pickerArray = ["Mohali","Noida"]
            
        }
            else if (dictTable[textFieldTag]["title"]!) == "Industry"
            {
                    
                    pickerArray = ["Intel","Mechanical"]
                
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
