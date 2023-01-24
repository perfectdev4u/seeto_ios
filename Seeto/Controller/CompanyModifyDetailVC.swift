//
//  CompanyModifyDetailVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 25/01/23.
//

import UIKit

class CompanyModifyDetailVC: UIViewController {

    var dictTable = [["title":"Company Name","type":"text","value":""],["title":"Industry","type":"text","value":""],["title":"Website","type":"text","value":""],["title":"LinkedIn Profile","type":"text","value":""],["title":"Company Foundation Date","type":"text","value":""],["title":"Company Size","type":"drop","value":""]]
    @IBOutlet var tblMain: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackAct(_ sender: UIButton) {
        
    }
    
   
    
}
extension CompanyModifyDetailVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "CandidateProfileCell"
        tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CandidateProfileCell
        cell.phoneCountryView.isHidden = true
        let attributedString = NSMutableAttributedString(
            string: (dictTable[indexPath.row]["title"]!),
            attributes: [NSAttributedString.Key.foregroundColor: grayColor])

        if (dictTable[indexPath.row]["type"]!) == "text"
        {
            cell.imgVector.isHidden = true
        }
        else
        {
            cell.imgVector.isHidden = false
        }
            cell.tfMain.attributedPlaceholder = attributedString

        cell.selectionStyle = .none
        return cell

    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        view.backgroundColor = backGroundColor
        let button = UIButton(frame: CGRect(x: 20, y: 25, width: self.view.frame.width - 60, height: 50))
        button.layer.cornerRadius = 10
        button.setTitle("Update", for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(btnApplyAct), for: .touchUpInside)
        button.backgroundColor = blueButtonColor
        view.addSubview(button)
        return view
    }
    @objc func btnApplyAct()
    {

        
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
