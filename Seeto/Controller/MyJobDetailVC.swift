//
//  MyJobDetailVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 07/01/23.
//

import UIKit

class MyJobDetailVC: UIViewController {
    var dictTable = [["title":"Position","value":"Loading..."],["title":"Experience Level","value":"Loading..."],["title":"Job Type","value":"Loading..."],["title":"Location","value":"Loading..."],["title":"Industry","value":"Loading..."],["title":"Website","value":"Loading..."],["title":"Linkedin Profile","value":"Loading..."],["title":"Company Foundation Date","value":"Loading..."],["title":"Company Size","value":"Loading..."]]
    @IBOutlet var tblMyJobDetail: UITableView!
    let screenSize: CGRect = UIScreen.main.bounds
     var jobId = ""
    var mainDict = NSDictionary.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        GetJobByIdApi()
        // Do any additional setup after loading the view.
    }
    func GetJobByIdApi()
    {
        ApiManager().postRequest(parameters: ["jobId": jobId], api: ApiManager.shared.GetJobById) { dataJson, error in
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
                      self.dictTable[0]["value"] = self.mainDict["position"] as? String ?? ""
                      self.dictTable[1]["value"] = experienceArray[( self.mainDict["experienceLevel"] as? Int) ?? 0]
                      self.dictTable[2]["value"] = jobArray[( self.mainDict["jobType"] as? Int) ?? 0]
                      self.dictTable[3]["value"] = JobLocationArray[( self.mainDict["jobLocation"] as? Int) ?? 0]
                      self.dictTable[4]["value"] = ""
                      self.dictTable[5]["value"] = self.mainDict["webSite"] as? String ?? ""
                      self.dictTable[6]["value"] = self.mainDict["linkedInProfile"] as? String ?? ""
                      self.dictTable[7]["value"] = converrDateFormat(string: self.mainDict["foundationDate"] as? String ?? "")
                      self.dictTable[8]["value"] = companyArray[(self.mainDict["companySize"] as? Int) ?? 0]

                      DispatchQueue.main.async {
                          
                          self.tblMyJobDetail.reloadData()
                      }
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
extension MyJobDetailVC : UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : dictTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let identifier = "CompanyDetailCell"
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CompanyDetailCell
            cell.lblTitle.text = self.mainDict["companyName"] as? String ?? "Loading..."
            if let string = self.mainDict["companyLogo"] as? String
            {
                cell.imgLogo.layer.cornerRadius = cell.imgLogo.frame.height / 2
                cell.imgLogo.sd_setImage(with: URL(string: string), placeholderImage: UIImage(named: "placeholderImg"))
            }
            cell.lblPosition.text = self.mainDict["position"] as? String ?? ""
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            let identifier = "MyJobDetailCell"
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MyJobDetailCell
            cell.myJobTitleLbl.text = (dictTable[indexPath.row]["title"] ?? "")
            cell.leadingMainView.constant = 20
            cell.trailingMainView.constant = 20
            if (dictTable[indexPath.row]["title"] ?? "") ==  "Website" || (dictTable[indexPath.row]["title"] ?? "") ==  "Linkedin Profile"
            {
                cell.myJobDataLbl.textColor = blueButtonColor
                let underlineAttriString = NSAttributedString(string: dictTable[indexPath.row]["value"]!,
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
                let underlineAttriString = NSAttributedString(string: dictTable[indexPath.row]["value"]!)
                cell.myJobDataLbl.attributedText = underlineAttriString
                cell.myJobDataLbl.textColor = UIColor.white
            }
            if indexPath.row == (tableView.numberOfRows(inSection: 1) - 1)
            {
                cell.seperaterView.isHidden = true
            }
            else
            {
                cell.seperaterView.isHidden = false
            }
            cell.seperaterView.backgroundColor = grayShadeColor
            cell.selectionStyle = .none
            return cell
            
        }
    }
    //MARK:- tappedOnLabel
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        var link = dictTable[gesture.view!.tag]["value"]!
        if !link.contains("https://")
        {
            link = "https://" + dictTable[gesture.view!.tag]["value"]!
        }
        guard let url = URL(string: link ) else { return }
        UIApplication.shared.open(url)

    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height:section == 1 ? 140 : 10))
        if section == 1
        {
            view.backgroundColor = backGroundColor
            let btnLike = UIButton()
            let btnDislike = UIButton()
            let imageLike = UIImageView(image:  UIImage(named: "tick"))
            imageLike.frame = CGRect(x: ((screenSize.width - 20) / 2) - 75, y: 62.5, width: 35, height: 35)
            imageLike.contentMode = .scaleAspectFill
            let imageDislike = UIImageView(image:  UIImage(named: "cross"))
            imageDislike.frame = CGRect(x: ((screenSize.width - 20) / 2) + 40, y:  62.5, width: 35, height: 35)
            imageDislike.contentMode = .scaleAspectFill

            btnLike.frame = CGRect(x: ((screenSize.width - 20) / 2) - 97.5, y: 40, width: 80, height: 80)
            btnLike.backgroundColor = likeButtonBackGroundColor
            btnLike.layer.cornerRadius = btnLike.frame.height / 2
            btnDislike.frame = CGRect(x: ((screenSize.width - 20) / 2) + 17.5, y: 40, width: 80, height: 80)
            btnDislike.layer.cornerRadius = btnLike.frame.height / 2
            btnDislike.backgroundColor = likeButtonBackGroundColor
//            btnDislike.setShadowButton()
//            btnLike.setShadowButton()
            btnDislike.addTarget(self, action: #selector(dislikeAct), for: .touchUpInside)
            btnLike.addTarget(self, action: #selector(likeAct), for: .touchUpInside)

            view.addSubview(btnDislike)
            view.addSubview(btnLike)
            view.addSubview(imageLike)
            view.addSubview(imageDislike)
        }
        return view
    }
    @objc func likeAct(_ sender : UIButton)
    {
        print("Liked")
    }
    
    @objc func dislikeAct(_ sender : UIButton)
    {
        print("Disliked")
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 10 : 160
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
