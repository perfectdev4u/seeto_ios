//
//  EmployerMainSettingVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 25/01/23.
//

import UIKit

class EmployerMainSettingVC: UIViewController {
   var candidateId = -1
    var mainDict = NSDictionary.init()
    var dictTable = [["title":"DOB","value":"Loading..."],["title":"Linkedin Profile","value":"Loading..."],["title":"Gender","value":"Loading..."],["title":"Current Location","value":"Loading..."],["title":"Current Position","value":"Loading..."],["title":"Experience Level","value":"Loading..."],["title":"Spoken Language","value":"Loading..."]]

    @IBOutlet var tblProfileSettings: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getCandidateApi()
        // Do any additional setup after loading the view.
    }
    func getCandidateApi()
    {
        ApiManager().postRequest(parameters: ["candidateId": candidateId], api: ApiManager.shared.GetCandidateById) { dataJson, error in
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
                      self.dictTable[0]["value"] = self.mainDict["dateOfBirth"] as? String ?? ""
                      self.dictTable[1]["value"] = self.mainDict["linkedInProfile"] as? String ?? ""
                      self.dictTable[2]["value"] = String(describing: self.mainDict["gender"] as AnyObject) == "2" ? "Female" : "Male"
                      self.dictTable[3]["value"] = self.mainDict["currentLocation"] as? String ?? ""
                      self.dictTable[4]["value"] = self.mainDict["currentPosition"] as? String ?? ""
                      self.dictTable[5]["value"] = experienceArray[( self.mainDict["experienceLevel"] as? Int) ?? 0]
                      self.dictTable[6]["value"] = self.mainDict["language"] as? String ?? "English"

                      
                      self.tblProfileSettings.reloadData()
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
extension EmployerMainSettingVC : UITableViewDelegate,UITableViewDataSource
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
            cell.lblName.text = self.mainDict["fullName"] as? String ?? ""
            cell.imgVideo.sd_setImage(with: URL(string: mainDict["thumbnailUrl"] as? String ?? ""), placeholderImage: UIImage(named: "placeholderImg"))
            cell.btnImageProfilr.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
            cell.imgEdit.image = UIImage(named: "player")
            cell.selectionStyle = .none
            return cell

        }
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
                if (dictTable[indexPath.row - 1]["title"] ?? "") ==  "Website" || (dictTable[indexPath.row - 1]["title"] ?? "") ==  "Linkedin Profile"
                {
                    cell.myJobDataLbl.textColor = blueButtonColor
                    let underlineAttriString = NSAttributedString(string: dictTable[indexPath.row - 1]["value"]!,
                                                              attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
                    cell.myJobDataLbl.isUserInteractionEnabled = true
                    cell.myJobDataLbl.tag = indexPath.row
                    cell.myJobDataLbl.attributedText = underlineAttriString

                    let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
                    tapgesture.numberOfTapsRequired = 1
                    cell.myJobDataLbl.addGestureRecognizer(tapgesture)

                }
                
                else
                {
                    let underlineAttriString = NSAttributedString(string: dictTable[indexPath.row - 1]["value"]!)

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

    //MARK:-
   @objc func playVideo()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResumeVideoPreviewVC") as! ResumeVideoPreviewVC
        vc.urlVideo = URL(string: mainDict["videoUrl"] as? String ?? "")
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
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: section == 1 ? 95 : .leastNormalMagnitude))
        view.backgroundColor = backGroundColor
        if section == 3
        {
            let button = UIButton(frame: CGRect(x: 20, y: 60, width: self.view.frame.width - 40, height: 50))
            button.layer.cornerRadius = 10
            button.setTitle("Contact", for: .normal)
            button.titleLabel?.font =  UIFont.systemFont(ofSize: 16, weight: .semibold)
            button.addTarget(self, action: #selector(btnShowCandidateDetailAct), for: .touchUpInside)
            button.backgroundColor = blueButtonColor
            view.addSubview(button)
        }
        return view
    }
    @objc func btnShowCandidateDetailAct()
    {

        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 3 ? 95 : .leastNormalMagnitude
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
