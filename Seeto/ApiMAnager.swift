//
//  ApiMAnager.swift
//  Seeto
//
//  Created by Paramveer Singh on 12/01/23.
//

import Foundation
import UIKit
import SwiftLoader


class ApiManager
{
    static let shared = ApiManager()
    
    let LoginPhoneApi = "Auth/ExternalLogin"
    let LoginEmailApi = "Auth/Register"

    func postRequest(parameters : [String: Any] ,api : String , completion: @escaping ([String: Any]?, Error?) -> Void) {

        //declare parameter as a dictionary which contains string as key and value combination.
        SwiftLoader.show(animated: true)
        print(api)
        print(parameters)
        //create the url with NSURL
        let url = URL(string: (baseURL + api))!

        //create the session object
        let session = URLSession.shared

        //now create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body
        } catch let error {
            SwiftLoader.hide()
            print(error.localizedDescription)
            completion(nil, error)
        }

        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
       request.addValue("application/json", forHTTPHeaderField: "Accept")

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                SwiftLoader.hide()
                completion(nil, error)
                return
            }

            guard let data = data else {
                SwiftLoader.hide()
                completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }

            do {
                //create json object from data
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    SwiftLoader.hide()
                    completion(nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
                    return
                }
                print(json)
                SwiftLoader.hide()
                completion(json, nil)
            } catch let error {
                SwiftLoader.hide()
                print(error.localizedDescription)
                completion(nil, error)
            }
        })

        task.resume()
    }
}
