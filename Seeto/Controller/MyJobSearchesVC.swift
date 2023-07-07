//
//  MyJobSearchesVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 07/01/23.
//

import UIKit

class MyJobSearchesVC: UIViewController, SearchDetailDelegate, DeleteIndexDelegate, JobDelegate {
//    func dataFromSearch(data: [NSDictionary], searchId: String) {
//        <#code#>
//    }
    
    func JobDone() {
        getJobSearchesApi()

    }
    
    func deleteIndex(index: Int) {
        arraySearch.remove(at: index)
        setUpView()
        self.tblJobSearches.reloadData()
    }
    
    @IBOutlet var viewOops: UIView!
    @IBOutlet var btnNewSearch: UIButton!
    
    func dataFromSearch(data: [NSDictionary], searchId: String) {
        arraySearch = data
        self.tblJobSearches.reloadData()
    }
    
    @IBAction func btnNewSearch(_ sender: UIButton) {
       
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ModifyJobSearchVC") as! ModifyJobSearchVC
            vc.fromHome = false
            vc.searchDetailDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
       
        
    }
    var arraySearch = [NSDictionary].init()
    var fromHome = false
    @IBOutlet var tblJobSearches: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        btnNewSearch.layer.cornerRadius = 10
        getJobSearchesApi()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
    }
       func setUpView()
        {
    
            if arraySearch.count == 0
            {
                viewOops.isHidden = false
                tblJobSearches.isHidden = true
            }
            else
            {
                viewOops.isHidden = true
                tblJobSearches.isHidden = false
    
            }
        }
    @IBAction func btnSettingsAct(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileSettingView") as! ProfileSettingView
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func getJobSearchesApi()
    {
        ApiManager().postRequest(parameters: ["page": 1,"pageSize": 1000], api: ApiManager.shared.GetAllJobSearch) { dataJson, error in
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
                            self.arraySearch = dataJson["data"] as? [NSDictionary] ?? []
                            if self.arraySearch.count == 0
                            {
                                self.viewOops.isHidden = false
                                self.viewOops.isHidden = false
                                self.tblJobSearches.isHidden = true
                            }
                            else
                            {
                                self.viewOops.isHidden = true
                                self.tblJobSearches.isHidden = false
                                
                            }
                            self.tblJobSearches.reloadData()
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
    
    @IBAction func btnBackAct(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure to exit ?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
          exit(1)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
            print("no")
        }))
        /*If you want work actionsheet on ipad
        then you have to use popoverPresentationController to present the actionsheet,
        otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = self.view.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
   
    
    func AddSearchApi(dictTable : NSDictionary)
    {
        
        var param = [
            "position" : dictTable["position"] as? String ?? "",
            "experienceLevel" : dictTable["experienceLevel"] as? Int ?? 0,
            "industryId":  dictTable["industryId"] as? Int ?? 0,
            "jobType" : dictTable["jobType"] as? Int ?? 0,
            "jobLocation" : dictTable["jobLocation"] as? Int ?? 0,
            "location" : dictTable["location"] as? String ?? "",
            "desiredSalary" : dictTable["desiredSalary"] as? Int ?? nil ,
            "page" : 1,
            "pageSize" : 10,
        ] as [String : Any]
        
        ApiManager().postRequest(parameters: param,api:  ApiManager.shared.SearchJobs) { dataJson, error in
            if let error = error
            {
                DispatchQueue.main.async {
                    
                    self.showToast(message: error.localizedDescription)
                }
            }
            else
            {
            if let dataJson = dataJson
                {
              if String(describing: (dataJson["statusCode"] as AnyObject)) == "200"
                {
                 
                if let dictArray = dataJson["data"] as? [NSDictionary]{
                    DispatchQueue.main.async {
                        if dictArray.count == 0
                        {
                            Toast.show(message: "No match found for your search", controller: self)

                        }
                        else
                        {
                            print(dictTable)
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
                            vc.mainDataArray = dictArray
                            vc.inputArray = dictTable
                            vc.searchJobId = String(describing: dictTable["searchId"] as AnyObject)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                  }
                }
                else
                {
                    DispatchQueue.main.async {

                      //  self.showToast(message: ()
                  Toast.show(message: errorMessage, controller: self)
                    }

                }
                
            }

            }
        }
    }
}

extension MyJobSearchesVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "MyJobSearchesCell"
        tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MyJobSearchesCell
        cell.lblLikes.text = arraySearch[indexPath.row]["mutualMatchCount"] as? String ?? "0"
        cell.lblDesignation.text = arraySearch[indexPath.row]["position"] as? String ?? ""
        cell.lblSkillLevel.text = experienceArray[(arraySearch[indexPath.row]["experienceLevel"] as? Int) ?? 0]
        cell.lblLikes.text = String(describing: arraySearch[indexPath.row]["likeCount"] as AnyObject)
        if indexPath.row == (tableView.numberOfRows(inSection: 0) - 1)
        {
            cell.seperatorView.isHidden = true
        }
        else
        {
            cell.seperatorView.isHidden = false
        }
        cell.btnLike.tag = indexPath.row
        cell.btnLike.addTarget(self, action:  #selector(btnLikeAct), for: .touchUpInside)
        cell.widthLblLikes.constant = cell.lblLikes.intrinsicContentSize.width
        cell.selectionStyle = .none
        return cell
        
    }
    @objc func btnLikeAct(_ sender : UIButton)
    {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "JobSearchDetailsVC") as! JobSearchDetailsVC
               vc.searchId = self.arraySearch[sender.tag]["searchId"] as? Int ?? -1
                self.navigationController?.pushViewController(vc, animated: true)

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AddSearchApi(dictTable: arraySearch[indexPath.row])

        
    }
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeleteSearchVC") as! DeleteSearchVC
            vc.index = indexPath.row
            vc.searchId = self.arraySearch[indexPath.row]["searchId"] as? Int ?? -1
            vc.deleteDelegate = self
            self.present(vc, animated: true)
            
            
        })
        let theImage: UIImage? = UIImage(named:"delete")?.withRenderingMode(.alwaysOriginal)
        
        deleteAction.image = theImage
        
        deleteAction.backgroundColor = grayShadeColor
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        view.backgroundColor = backGroundColor
        let button = UIButton(frame: CGRect(x: 20, y: 35, width: self.view.frame.width - 40, height: 50))
        button.layer.cornerRadius = 10
        button.setTitle("New Search", for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(btnNewSearchAct), for: .touchUpInside)
        button.backgroundColor = blueButtonColor
        view.addSubview(button)
        return view
    }
    @objc func btnNewSearchAct()
    {
       
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ModifyJobSearchVC") as! ModifyJobSearchVC
            vc.fromHome = false
            vc.searchDetailDelegate = self
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
