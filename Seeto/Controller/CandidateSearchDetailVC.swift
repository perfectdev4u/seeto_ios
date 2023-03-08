//
//  CandidateSearchDetailVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 24/01/23.
//

import UIKit

class CandidateSearchDetailVC: UIViewController {
     var jobId = -1
    @IBOutlet var tblCandidateSearch: UITableView!
    var dictTable = [["title":"Position","value":"Loading..."],["title":"Experience Level","value":"Loading..."],["title":"Job Type","value":"Loading..."],["title":"Location","value":"Loading..."]]
    var mainDict = NSDictionary.init()
    var matchCandidateArray = [NSDictionary].init()
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
                      self.dictTable[1]["value"] = experienceArray[( self.mainDict["experienceLevel"] as? Int) ?? 0]
                      self.dictTable[2]["value"] = jobArray[( self.mainDict["jobType"] as? Int) ?? 0]
                      self.dictTable[3]["value"] = self.mainDict["location"] as? String ?? ""
                      self.matchCandidateArray = self.mainDict["machedCandidates"] as? [NSDictionary] ?? []
                      self.tblCandidateSearch.reloadData()
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

extension CandidateSearchDetailVC : UITableViewDelegate,UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.backgroundColor = backGroundColor
        return view

    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 2 ? 25 : .leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: section == 2 ? 80 : .leastNormalMagnitude))
        let label = UILabel(frame: CGRect(x: 0, y: 30, width: self.view.frame.width, height:section == 2 ? 30 : .leastNormalMagnitude))
        label.text = section == 2 ? "Your Matches" : ""
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        view.backgroundColor = backGroundColor
        view.addSubview(label)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  section == 2 ? 80 : .leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 1
        }
        else if section == 1
        {
            return  dictTable.count + 1
        }
      
        return matchCandidateArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmployerMainSettingVC") as! EmployerMainSettingVC
            vc.candidateId = matchCandidateArray[indexPath.row]["candidateId"] as? Int ?? -1
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let identifier = "ProfileViewCell"
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ProfileViewCell
            cell.selectionStyle = .none
            cell.lblName.text = mainDict["position"] as? String ?? "Loading..."
            cell.imgVideo.sd_setImage(with: URL(string: mainDict["thumbnailUrl"] as? String ?? ""), placeholderImage: UIImage(named: "placeholderImg"))
            cell.viewEdit.isHidden = false
            cell.imgEdit.image = UIImage(named: "player")
            cell.btnImageProfilr.addTarget(self, action: #selector(playVideo), for: .touchUpInside)

            return cell
        }
       else if indexPath.section == 1
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
            cell.companyTitle.text = matchCandidateArray[indexPath.row]["name"] as? String ?? "N/A"
            cell.noOfEmployeesLbl.text = matchCandidateArray[indexPath.row]["position"] as? String ?? "N/A"
            cell.imgThumb.sd_setImage(with: URL(string: matchCandidateArray[indexPath.row]["thumbnailUrl"] as? String ?? ""), placeholderImage: UIImage(named: "placeholderImg"))

            cell.selectionStyle = .none
            return cell
        }
    }
    //MARK:-
    @objc func playVideo(_ sender : UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResumeVideoPreviewVC") as! ResumeVideoPreviewVC
        vc.urlVideo = URL(string: mainDict["videoUrl"] as? String ?? "")
        self.navigationController?.pushViewController(vc, animated: true)

    }

    
}
