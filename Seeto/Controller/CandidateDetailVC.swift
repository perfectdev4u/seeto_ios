//
//  CandidateDetailVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 24/01/23.
//

//
//  MyJobDetailVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 07/01/23.
//

import UIKit
protocol LikeDislikeDelegate
{
    func dataLikeDislike(id : Int,isMatch : Bool,index : Int)
    
}
class CandidateDetailVC: UIViewController {
    var dictTable = [["title":"DOB","value":"Loading..."],["title":"Gender","value":"Loading..."],["title":"Current location","value":"Loading..."],["title":"Current Position","value":"Loading..."],["title":"Experience Level","value":"Loading..."],["title":"Spoken Language","value":"Loading..."]]
    var candidateId = ""
    @IBOutlet var tblCandidateDetail: UITableView!
    let screenSize: CGRect = UIScreen.main.bounds
    var mainDict = NSDictionary.init()
    var index : Int = -1
    var likeDislikeDelegate : LikeDislikeDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        getCandidateApi()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(MyJobDetailVC.rightSwiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(swipeRight)

        // Do any additional setup after loading the view.
    }
    @objc func rightSwiped(_ sender : UISwipeGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: true)
      //  Toast.show(message:"Right", controller: self)
    }

    func getCandidateApi()
    {
        ApiManager().postRequest(parameters: ["candidateId": candidateId], api: ApiManager.shared.GetCandidateById) { dataJson, error in
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
                      self.dictTable[0]["value"] = converrDateFormat(string: self.mainDict["dateOfBirth"] as? String ?? "")
                      self.dictTable[1]["value"] = String(describing: self.mainDict["gender"] as AnyObject) == "2" ? "Female" : "Male"
                      self.dictTable[2]["value"] = self.mainDict["currentLocation"] as? String ?? ""
                      self.dictTable[3]["value"] = self.mainDict["currentPosition"] as? String ?? ""
                      self.dictTable[4]["value"] = experienceArray[( self.mainDict["experienceLevel"] as? Int) ?? 0]
                      self.dictTable[5]["value"] = self.mainDict["language"] as? String ?? "English"

                      
                      self.tblCandidateDetail.reloadData()
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

extension CandidateDetailVC : UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : dictTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let identifier = "CompanyDetailCell"
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CompanyDetailCell
            cell.lblTitle.text = mainDict["fullName"] as? String ?? ""
            cell.lblPosition.text = mainDict["currentPosition"] as? String ?? ""
            if let string = self.mainDict["profileImage"] as? String
            {
                cell.imgLogo.layer.cornerRadius = cell.imgLogo.frame.height / 2
                cell.imgLogo.sd_setImage(with: URL(string: string), placeholderImage: UIImage(named: "placeholderImg"))
            }
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            let identifier = "MyJobDetailCell"
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MyJobDetailCell
            cell.myJobTitleLbl.text = (dictTable[indexPath.row]["title"] ?? "")
            cell.leadingMainView.constant = 20
            cell.trailingMainView.constant = 20
            if (dictTable[indexPath.row]["title"] ?? "") ==  "Website" || (dictTable[indexPath.row]["title"] ?? "") ==  "Linkedin Profile"
            {
                cell.myJobDataLbl.textColor = blueButtonColor
                let underlineAttriString = NSAttributedString(string: dictTable[indexPath.row]["value"]!,
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
                cell.myJobDataLbl.text = dictTable[indexPath.row]["value"]

                cell.myJobDataLbl.textColor = UIColor.white
            }
            if indexPath.row == (tableView.numberOfRows(inSection: 1) - 1)
            {
                cell.seperaterView.isHidden = true
            }
            else
            {
                cell.seperaterView.isHidden = false
            }
            cell.seperaterView.backgroundColor = grayShadeColor
            cell.selectionStyle = .none
            return cell
            
        }
    }
    //MARK:- tappedOnLabel
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        var link = dictTable[gesture.view!.tag]["value"]!
        if !link.contains("https://")
        {
            link = "https://" + dictTable[gesture.view!.tag]["value"]!
        }
        guard let url = URL(string: link ) else { return }
        UIApplication.shared.open(url)

    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height:section == 1 ? 140 : 10))
        if section == 1
        {
            view.backgroundColor = backGroundColor
            let btnLike = UIButton()
            let btnDislike = UIButton()
            let imageLike = UIImageView(image:  UIImage(named: "tick"))
            imageLike.frame = CGRect(x: ((screenSize.width - 20) / 2) - 75, y: 62.5, width: 35, height: 35)
            imageLike.contentMode = .scaleAspectFill
            let imageDislike = UIImageView(image:  UIImage(named: "cross"))
            imageDislike.frame = CGRect(x: ((screenSize.width - 20) / 2) + 40, y:  62.5, width: 35, height: 35)
            imageDislike.contentMode = .scaleAspectFill

            btnLike.frame = CGRect(x: ((screenSize.width - 20) / 2) - 97.5, y: 40, width: 80, height: 80)
            btnLike.backgroundColor = likeButtonBackGroundColor
            btnLike.layer.cornerRadius = btnLike.frame.height / 2
            btnDislike.frame = CGRect(x: ((screenSize.width - 20) / 2) + 17.5, y: 40, width: 80, height: 80)
            btnDislike.layer.cornerRadius = btnLike.frame.height / 2
            btnDislike.backgroundColor = likeButtonBackGroundColor
//            btnDislike.setShadowButton()
//            btnLike.setShadowButton()
            btnDislike.addTarget(self, action: #selector(dislikeAct), for: .touchUpInside)
            btnLike.addTarget(self, action: #selector(likeAct), for: .touchUpInside)

            view.addSubview(btnDislike)
            view.addSubview(btnLike)
            view.addSubview(imageLike)
            view.addSubview(imageDislike)
        }
        return view
    }
    @objc func likeAct(_ sender : UIButton)
    {
        likeDislikeDelegate.dataLikeDislike(id: Int(candidateId) ?? -1, isMatch: true, index: index)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dislikeAct(_ sender : UIButton)
    {
        likeDislikeDelegate.dataLikeDislike(id: Int(candidateId) ?? -1, isMatch: false, index: index)
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 10 : 160
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
