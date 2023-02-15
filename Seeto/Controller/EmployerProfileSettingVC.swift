//
//  EmployerProfileSettingVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 25/01/23.
//

import UIKit
import SwiftLoader

class EmployerProfileSettingVC: UIViewController {

    var dictTable = [["title":"Company name","value":"Loading..."],["title":"Industry","value":"Loading..."],["title":"Website","value":"Loading..."],["title":"Linkedin Profile","value":"Loading..."],["title":"Company Foundation Date","value":"Loading..."],["title":"Company Size","value":"Loading..."]]
    var mainDataJson = NSDictionary.init()

    @IBOutlet var tblProfileSettings: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
                      self.dictTable[0]["value"] = ((dataJson["data"] as! NSDictionary)["companyName"] as! String)
                      self.dictTable[1]["value"] = ((dataJson["data"] as! NSDictionary)["industry"] as! String)
                      self.dictTable[2]["value"] = ((dataJson["data"] as! NSDictionary)["webSite"] as! String)
                      self.dictTable[3]["value"] = String(describing: ((dataJson["data"] as! NSDictionary)["linkedInProfile"] as AnyObject))
                      self.dictTable[4]["value"] = ((dataJson["data"] as! NSDictionary)["foundationDate"] as! String)
                      self.dictTable[5]["value"] = String(describing: ((dataJson["data"] as! NSDictionary)["companySize"] as AnyObject))  == "1000" ? "1000" : "> 1000"
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
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: .leastNormalMagnitude))
      
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
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
