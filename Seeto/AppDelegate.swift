//
//  AppDelegate.swift
//  Seeto
//
//  Created by Paramveer Singh on 04/01/23.
//

import UIKit
import FBSDKCoreKit
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FBSDKCoreKit.ApplicationDelegate.shared.application(
                   application,
                   didFinishLaunchingWithOptions: launchOptions
               )
        GIDSignIn.sharedInstance().clientID = "72919610538-rhqe3h7lrovdsb254q3dg9kua4c6o0nm.apps.googleusercontent.com"
        // 2
        // 3
//        GIDSignIn.sharedInstance().restorePreviousSignIn()

//        GIDSignIn.sharedInstance.clientID = "[OAuth_Client_ID]"
        // Override point for customization after application launch.
        return true
    }
 
    func application(
      _ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
      var handled: Bool

        handled = GIDSignIn.sharedInstance().handle(url)
      if handled {
        return true
      }

      // Handle other custom URL types.

      // If not handled by this app, return false.
      return false
    }

      // Handle other custom URL types.

      // If not handled by this app, return false.
   // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    

}

