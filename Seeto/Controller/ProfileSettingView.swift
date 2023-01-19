//
//  ProfileSettingView.swift
//  Seeto
//
//  Created by Paramveer Singh on 10/01/23.
//

import UIKit

class ProfileSettingView: UIViewController {
    var dictTable = [["title":"Name","value":"Vrinda Gupta"],["title":"DOB","value":"23-11-1999"],["title":"Linkedin Profile","value":"www.vrinda.com"],["title":"Gender","value":"Female"],["title":"Current Location","value":"India"],["title":"Current Position","value":"Nodejs Developer"],["title":"Experience Level","value":"Entry level"],["title":"Spoken Language","value":"English"]]

    @IBOutlet var tblProfileSettings: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnBackAct(_ sender: UIButton) {
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
