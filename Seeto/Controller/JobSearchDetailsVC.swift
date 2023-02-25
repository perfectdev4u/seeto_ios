//
//  JobSearchDetailsVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 07/01/23.
//

import UIKit

class JobSearchDetailsVC: UIViewController {
    var dictTable = [["title":"Position","value":"Loading..."],["title":"Experience Level","value":"Loading..."],["title":"Job Type","value":"Loading..."],["title":"Location","value":"Loading..."]]
    var jobId = -1
    var mainDict = NSDictionary.init()
    var matchEmployerArray = [NSDictionary].init()
    @IBOutlet var tblViewJobSearchDetail: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getJobWithCandidateApi()
        // Do any additional setup after loading the view.
    }
    func getJobWithCandidateApi()
    {
        ApiManager().postRequest(parameters: ["jobId": jobId], api: ApiManager.shared.GetJobWithCandidate) { dataJson, error in
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
                      self.dictTable[1]["value"] = "Entry Level"
                      self.dictTable[2]["value"] = String(describing: self.mainDict["jobType"] as AnyObject) == "2" ? "HR" : "IT"
                      self.dictTable[3]["value"] = self.mainDict["location"] as? String ?? ""
                      self.matchEmployerArray = self.mainDict["machedCandidates"] as? [NSDictionary] ?? []
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

extension JobSearchDetailsVC : UITableViewDelegate,UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.backgroundColor = backGroundColor
        return view

    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 1 ? .leastNormalMagnitude : 25
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: section == 1 ? 80 : .leastNormalMagnitude))
        let label = UILabel(frame: CGRect(x: 0, y: 30, width: self.view.frame.width, height:section == 1 ? 30 : .leastNormalMagnitude))
        label.text = section == 0 ? "" : "Matches"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        view.backgroundColor = backGroundColor
        view.addSubview(label)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  section == 1 ? 80 : .leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? dictTable.count + 1  : 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                let identifier = "DetailsCell"
                tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! DetailsCell
                cell.lblDetails.isHidden = true
                cell.imgDown.isHidden = true
                cell.heightCell.constant = 20
                cell.selectionStyle = .none
                return cell
                
            }
            
                let identifier = "MyJobDetailCell"
                tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MyJobDetailCell
                cell.myJobTitleLbl.text = (dictTable[indexPath.row - 1]["title"] ?? "")
                cell.myJobDataLbl.text = dictTable[indexPath.row - 1]["value"]
                cell.mainView.backgroundColor = darkShadeColor
                cell.leadingMainView.constant = 20
                cell.trailingMainView.constant = 20
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
        else
        {
            let identifier = "MatchedEmployerCell"
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MatchedEmployerCell
            if indexPath.row == (tableView.numberOfRows(inSection: 1) - 1)
            {
                cell.seperatorView.isHidden = true
            }
            else
            {
                cell.seperatorView.isHidden = false
            }
            cell.selectionStyle = .none
            return cell
        }

    }
   

    
}
