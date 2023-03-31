//
//  DeleteSearchVC.swift
//  Seeto
//
//  Created by Paramveer Singh on 07/01/23.
//

import UIKit

protocol DeleteIndexDelegate
{
    func deleteIndex(index : Int)
}
class DeleteSearchVC: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet var backView: UIView!
    @IBOutlet var btnConfirm: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.cornerRadius = 10
        btnConfirm.layer.cornerRadius = 10
        addBlurToView()
        // Do any additional setup after loading the view.
    }
    var index = 0
    var searchId = -1
    func addBlurToView() {
        var blurEffect: UIBlurEffect!
        if #available(ios 10.0, *) {
            blurEffect = UIBlurEffect(style: .dark)
        } else {
            blurEffect = UIBlurEffect(style: .light)
        }
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = backView.bounds
        blurredEffectView.alpha = 0.8
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backView.addSubview(blurredEffectView)
    }
    var deleteDelegate : JobDelegate?

    @IBAction func btnConfirmAct(_ sender: Any) {
        //deleteIndexDelegate.deleteIndex(index: index)
        deleteSearchApi()

    }
    func deleteSearchApi()
    {
        ApiManager().postRequest(parameters: [  "searchId": searchId
], api: ApiManager.shared.DeleteJobFormSearch) { dataJson, error in
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
                      Toast.show(message:(dataJson["returnMessage"] as! [String])[0], controller: self)
                      self.deleteDelegate?.JobDone()
                      self.dismiss(animated: true)
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

    @IBAction func btnCancelAct(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
