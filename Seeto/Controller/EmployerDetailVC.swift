//
//  EmployerDetailVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 08/01/23.
//

import UIKit

class EmployerDetailVC: UIViewController {
    var dictTable = [["title":"Industry","value":"Loading..."],["title":"Website","value":"Loading..."],["title":"Linkedin Profile","value":"Loading..."],["title":"Company Foundation Date","value":"Loading..."],["title":"Company Size","value":"100000"]]
    var employerId = 0
    var mainDict = NSDictionary.init()
    var position = ""
    @IBOutlet var tblEmployerDetail: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getEmployerApi()
    }
    func getEmployerApi()
    {
        ApiManager().postRequest(parameters: ["employerId": employerId], api: ApiManager.shared.GetEmployerById) { dataJson, error in
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
                      self.mainDict = dataJson["data"] as? NSDictionary ?? [:]
                      self.dictTable[0]["value"] = self.mainDict["industry"] as? String ?? ""
                      self.dictTable[1]["value"] = self.mainDict["webSite"] as? String ?? ""
                      self.dictTable[2]["value"] = String(describing: self.mainDict["linkedInProfile"] as AnyObject)
                      self.dictTable[3]["value"] = converrDateFormat(string: self.mainDict["foundationDate"] as? String ?? "")
                      self.dictTable[4]["value"] = companyArray[(self.mainDict["companySize"] as? Int) ?? 0]

                      
                      self.tblEmployerDetail.reloadData()
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
extension EmployerDetailVC : UITableViewDelegate,UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 2 ?  dictTable.count + 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
                let identifier = "CongratsCell"
                tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CongratsCell
                cell.selectionStyle = .none
                return cell
        }
        else if indexPath.section == 1
        {
            let identifier = "CompanyDetailCell"
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CompanyDetailCell
            cell.lblTitle.text = self.mainDict["companyName"] as? String ?? ""
            cell.lblPosition.text = position
            let companyLogoUrl =  self.mainDict["companyLogo"] as? String ?? ""
            cell.imgLogo.sd_setImage(with: URL(string: companyLogoUrl), placeholderImage: UIImage(named: "placeholderImg"))
            cell.selectionStyle = .none
            return cell

            
        }
        else
        {
            if indexPath.row == 0
            {
                let identifier = "DetailsCell"
                tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! DetailsCell
                cell.imgDown.isHidden = true
                cell.lblDetails.isHidden = true
                cell.heightCell.constant = 20
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
                let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
                tapgesture.numberOfTapsRequired = 1
                cell.myJobDataLbl.tag = indexPath.row
                if (dictTable[indexPath.row - 1]["title"] ?? "") ==  "Website" || (dictTable[indexPath.row - 1]["title"] ?? "") ==  "Linkedin Profile"
                {
                    cell.myJobDataLbl.textColor = blueButtonColor
                    let underlineAttriString = NSAttributedString(string: dictTable[indexPath.row - 1]["value"]!,
                                                              attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
                    cell.myJobDataLbl.attributedText = underlineAttriString
                    cell.myJobDataLbl.isUserInteractionEnabled = true
                    cell.myJobDataLbl.addGestureRecognizer(tapgesture)

                }
                else
                {
                    let AttriString = NSAttributedString(string: dictTable[indexPath.row - 1]["value"]!)
                    cell.myJobDataLbl.attributedText = AttriString
                    cell.myJobDataLbl.removeGestureRecognizer(tapgesture)
                    cell.myJobDataLbl.textColor = UIColor.white
                    cell.myJobDataLbl.isUserInteractionEnabled = false

                }
                if indexPath.row == (tableView.numberOfRows(inSection: 2) - 1)
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
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.backgroundColor = backGroundColor
        return view

    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? .leastNormalMagnitude : 20
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height:  .leastNormalMagnitude))
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
   
    
}
