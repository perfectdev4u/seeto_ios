//
//  JobsVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 27/01/23.
//

import UIKit

class JobsVC: UIViewController {

    @IBOutlet var tblJob: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnSettings(_ sender: Any) {
    }
    
    
}

extension JobsVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "MyJobSearchesCell"
        tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MyJobSearchesCell
        cell.viewPlay.isHidden = false
        cell.heightPic.constant = 55
        cell.widthPic.constant = 55
        cell.imgMain.image = UIImage(named: "video")
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
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeleteJobVC") as! DeleteJobVC
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
        button.setTitle("Add New Job", for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(btnNewSearchAct), for: .touchUpInside)
        button.backgroundColor = blueButtonColor
        view.addSubview(button)
        return view
    }
    @objc func btnNewSearchAct()
    {
        Toast.show(message:"Under Development", controller: self)
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
