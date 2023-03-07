//
//  MyJobSearchesVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 07/01/23.
//

import UIKit

class MyJobSearchesVC: UIViewController, SearchDetailDelegate, DeleteIndexDelegate {
    func deleteIndex(index: Int) {
        arraySearch.remove(at: index)
        setUpView()
        self.tblJobSearches.reloadData()
    }
    
    @IBOutlet var viewOops: UIView!
    @IBOutlet var btnNewSearch: UIButton!

    func dataFromSearch(data: [NSDictionary]) {
        arraySearch = data
        self.tblJobSearches.reloadData()
    }
    
    @IBAction func btnNewSearch(_ sender: UIButton) {
        if fromHome == false
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ModifyJobSearchVC") as! ModifyJobSearchVC
            vc.fromHome = fromHome
            vc.searchDetailDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)

        }
    }
    var arraySearch = [NSDictionary].init()
    var fromHome = false
    @IBOutlet var tblJobSearches: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNewSearch.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpView()
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
    
    @IBAction func btnBackAct(_ sender: Any) {
       
            self.navigationController?.popViewController(animated: true)
    
       
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
        cell.lblLikes.text = arraySearch[indexPath.row]["mutualMatchCount"] as? String ?? ""
        cell.lblDesignation.text = arraySearch[indexPath.row]["position"] as? String ?? ""
        cell.lblSkillLevel.text = experienceArray[(arraySearch[indexPath.row]["experienceLevel"] as? Int) ?? 0]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "JobSearchDetailsVC") as! JobSearchDetailsVC
        vc.jobId = self.arraySearch[indexPath.row]["jobId"] as? Int ?? -1
        self.navigationController?.pushViewController(vc, animated: true)

    }
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeleteSearchVC") as! DeleteSearchVC
            vc.index = indexPath.row
            vc.deleteIndexDelegate = self
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
        if fromHome == false
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ModifyJobSearchVC") as! ModifyJobSearchVC
            vc.fromHome = fromHome
            vc.searchDetailDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)

        }
        
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
