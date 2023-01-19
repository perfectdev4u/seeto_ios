//
//  EmployerDetailVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 08/01/23.
//

import UIKit

class EmployerDetailVC: UIViewController {
    var dictTable = [["title":"Industry","value":"IT"],["title":"Website","value":"www.Apple.com"],["title":"Linkedin Profile","value":"www.Apple.com"],["title":"Company Foundation Date","value":"23-11-1999"],["title":"Company Size","value":"100000"]]

    @IBOutlet var tblEmployerDetail: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnBackAct(_ sender: UIButton) {
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
