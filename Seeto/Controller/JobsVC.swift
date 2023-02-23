//
//  JobsVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 27/01/23.
//

import UIKit

class JobsVC: UIViewController,JobDelegate {
    func JobDone() {
        getJobsApi()
    }
    
    var mainArray = [NSDictionary].init()
    @IBOutlet var tblJob: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getJobsApi()
        // Do any additional setup after loading the view.
    }
    
    func getJobsApi()
    {
        ApiManager().postRequest(parameters: [:], api: ApiManager.shared.GetMyJobs) { dataJson, error in
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
                      self.mainArray = dataJson["data"] as? [NSDictionary] ?? []
                      self.tblJob.reloadData()
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

    @IBAction func btnSettings(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension JobsVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "MyJobSearchesCell"
        tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MyJobSearchesCell
        cell.viewPlay.isHidden = false
        cell.heightPic.constant = 45
        cell.widthPic.constant = 45
        cell.imgMain.sd_setImage(with: URL(string: mainArray[indexPath.row]["thumbnailUrl"] as? String ?? ""), placeholderImage: UIImage(named: "AppIcon"))
        cell.imgMain.layer.cornerRadius = cell.imgMain.frame.height / 2
        cell.lblSkillLevel.text = "Fresher"
        cell.lblDesignation.text = mainArray[indexPath.row]["position"] as? String ?? ""
        cell.lblLikes.text = String(describing:  mainArray[indexPath.row]["matchCount"] as AnyObject)
        cell.btnPlayVideo.tag = indexPath.row
        cell.btnPlayVideo.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        if indexPath.row == (tableView.numberOfRows(inSection: 0) - 1)
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
    //MARK:-
    @objc func playVideo(_ sender : UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResumeVideoPreviewVC") as! ResumeVideoPreviewVC
        vc.urlVideo = URL(string: mainArray[sender.tag]["videoUrl"] as? String ?? "")
        self.navigationController?.pushViewController(vc, animated: true)

    }
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeleteJobVC") as! DeleteJobVC
            vc.jobId = self.mainArray[indexPath.row]["jobId"] as? Int ?? -1
            vc.deleteDelegate = self
            self.present(vc, animated: true)

            
        })
        let theImage: UIImage? = UIImage(named:"delete")?.withRenderingMode(.alwaysOriginal)

        deleteAction.image = theImage

        deleteAction.backgroundColor = grayShadeColor

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CandidateSearchDetailVC") as! CandidateSearchDetailVC
        vc.jobId = self.mainArray[indexPath.row]["jobId"] as? Int ?? -1
        self.navigationController?.pushViewController(vc, animated: true)
  
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        view.backgroundColor = backGroundColor
        let button = UIButton(frame: CGRect(x: 20, y: 35, width: self.view.frame.width - 40, height: 50))
        button.layer.cornerRadius = 10
        button.setTitle("Add New Job", for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(btnNewSearchAct), for: .touchUpInside)
        button.backgroundColor = blueButtonColor
        view.addSubview(button)
        return view
    }
    @objc func btnNewSearchAct()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddNewJobAndVideoVC") as! AddNewJobAndVideoVC
        vc.jobDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
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
