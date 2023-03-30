//
//  LoginViewController.swift
//  Seeto
//
//  Created by Paramveer Singh on 05/01/23.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices
class LoginViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @IBOutlet var btnAppleLogin: UIButton!
    @IBOutlet var btnFacebook: UIButton!
    @IBOutlet var btnEmail: UIButton!
    @IBOutlet var btnGmail: UIButton!
    @IBOutlet var btnPhone: UIButton!
    
    @IBOutlet var btnApple: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScreen()
    }
   
    func setUpScreen()
    {
        btnFacebook.layer.cornerRadius = 10
        btnEmail.layer.cornerRadius = 10
        btnGmail.layer.cornerRadius = 10
        btnPhone.layer.cornerRadius = 10
        btnApple.layer.cornerRadius = 10
        if let token = AccessToken.current,
                !token.isExpired {
                // User is logged in, do work such as go to next view controller.
            }
        GIDSignIn.sharedInstance().delegate = self
    }
    @IBAction func btnAppleLogin(_ sender: UIButton) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
            
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()

        
    }
    @IBAction func btnEmailAct(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhonenumberScreenVC") as! PhonenumberScreenVC
        vc.email = true
        self.navigationController?.pushViewController(vc, animated: true)

    }

    @IBAction func btnPhoneAct(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhonenumberScreenVC") as! PhonenumberScreenVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnFacebookAct(_ sender: UIButton) {
        let fbLoginManager : LoginManager = LoginManager()
          fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self){ (result, error) -> Void in
              if (error == nil){
                  let fbloginresult : LoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                        return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                  self.getFBUserData()
                }
              }
            }
    }
    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
           if (error == nil){
               if let id =  (result as? NSDictionary)!["id"] as? AnyObject,let email =  (result as? NSDictionary)!["email"] as? AnyObject
               {
                   DispatchQueue.main.async {
                       self.verifyApi(grantType: "facebook", externalLogin: String(describing:id), email: String(describing:email))
                   }
               }
             //everything works print the user data
             print(result)
           }
         })
       }
     }
    func verifyApi(grantType : String,externalLogin : String,email : String)
    {
       
        let params = ["grantType" : grantType,"extrenalLoginToken" : externalLogin,  "email": email
] as [String : Any]
        
        ApiManager().postRequest(parameters: params,api:  ApiManager.shared.LoginPhoneApi) { dataJson, error in
            if let error = error
            {
                self.showToast(message: error.localizedDescription)
            }
            else
            {
            if let dataJson = dataJson
                {
              if String(describing: (dataJson["statusCode"] as AnyObject)) == "200"
                {
                if let dict = dataJson["data"] as? NSDictionary{
                    UserDefaults.standard.set((dict["access_token"] as? String) ?? "", forKey: "accessToken")
                    UserDefaults.standard.set((dict["userType"] as? Int) ?? "", forKey: "userType")
                    UserDefaults.standard.set(email, forKey: "email")

                    DispatchQueue.main.async {
                        if let userType = (dict["userType"] as? Int)
                        {
                            if userType == 0
                            {
                                super.navigateToController(storyboardId: StoryboardId.standard.appCategoryVC)
                            }
                            else if userType == 1
                            {
                                super.navigateToController(storyboardId: StoryboardId.standard.jobsVC)
                            }
                            else if userType == 2
                            {
                                super.navigateToController(storyboardId: StoryboardId.standard.myJobSearchesVC)
                            }
                        }
                      //  self.showToast(message: ()
                    }
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

    @IBAction func btnGoogleLoginAct(_ sender: UIButton) {

        GIDSignIn.sharedInstance().presentingViewController = self

        GIDSignIn.sharedInstance()?.signIn()

    }
    @IBAction func btnEmailLogin(_ sender: UIButton) {
    }
}

extension LoginViewController: GIDSignInDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!

    }
    // ASAuthorizationControllerDelegate function for successful authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user ?? ""
//            let userFirstName = appleIDCredential.fullName?.givenName
//            let userLastName = appleIDCredential.fullName?.familyName
            let userEmail = appleIDCredential.email ?? ""
            self.verifyApi(grantType: "apple", externalLogin: userIdentifier , email: userEmail)

//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppCategoryVC") as! AppCategoryVC
//            vc.appleLogin = true
//            self.navigationController?.pushViewController(vc, animated: true)

            //Navigate to other view controller
        }
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        // Check for sign in error
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        self.verifyApi(grantType: "google", externalLogin: user.userID ?? "", email: user.profile.email ?? "")

       
    }
    
}
