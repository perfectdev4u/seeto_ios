//
//  ProfileSettingView.swift
//  Seeto
//
//  Created by Paramveer Singh on 10/01/23.
//

import UIKit
import SDWebImage
class ProfileSettingView: UIViewController {
    var dictTable = [["title":"Name","value":"Loading..."],["title":"DOB","value":"Loading..."],["title":"Linkedin Profile","value":"Loading..."],["title":"Gender","value":"Loading..."],["title":"Current Location","value":"Loading..."],["title":"Current Position","value":"Loading..."],["title":"Experience Level","value":"Loading..."],["title":"Spoken Language","value":"Loading..."]]
    var mainDataJson = NSDictionary.init()
    @IBOutlet var tblProfileSettings: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getCandidateProfileApi()
        // Do any additional setup after loading the view.
    }
    func getCandidateProfileApi()
    {
        ApiManager().getRequest(api: ApiManager.shared.GetCandidateProfile) { dataJson, error in
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
                      self.dictTable[0]["value"] = ((dataJson["data"] as! NSDictionary)["firstName"] as! String) + " " +  ((dataJson["data"] as! NSDictionary)["lastName"] as! String)
                      self.dictTable[1]["value"] = ((dataJson["data"] as! NSDictionary)["dateOfBirth"] as! String)
                      self.dictTable[2]["value"] = ((dataJson["data"] as! NSDictionary)["linkedInProfile"] as! String)
                      self.dictTable[3]["value"] = String(describing: ((dataJson["data"] as! NSDictionary)["gender"] as AnyObject))
                      self.dictTable[4]["value"] = ((dataJson["data"] as! NSDictionary)["currentLocation"] as! String)
                      self.dictTable[5]["value"] = ((dataJson["data"] as! NSDictionary)["currentPosition"] as! String)
                      self.dictTable[6]["value"] = String(describing: ((dataJson["data"] as! NSDictionary)["experienceLevel"] as AnyObject))
//                      self.dictTable[7]["value"] = ((dataJson["data"] as! NSDictionary)["firstName"] as! String)
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
                cell.imgVideo.sd_setImage(with: URL(string: ((mainDataJson["data"] as! NSDictionary)["profileImage"] as! String)), placeholderImage: UIImage(named: "AppIcon"))

            }
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
                    cell.myJobDataLbl.text = dictTable[indexPath.row - 1]["value"]
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
