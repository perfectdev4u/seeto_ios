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
    let SignInApi = "Auth/SignIn"

    let GetCandidateProfile = "User/GetCandidateProfile"
    let GetEmployerProfile = "User/GetEmployerProfile"
    let UpdateCandidateProfile = "User/UpdateCandidateProfile"
    let UpdateEmployerProfile = "User/UpdateEmployerProfile"
    let UploadVideo = "User/UploadVideo"
    let AddJobs = "Job/AddJobs"
    let GetMyJobs = "Job/GetMyJobs"
    let DeleteJob = "Job/DeleteJob"
    let GetJobWithCandidate = "Job/GetJobWithCandidate"
    let SearchJob = "Job/SearchJob"
    let GetCandidateById = "User/GetCandidateById"
    let CandidateMatchesList = "MatchOrPass/CandidateMatchesList"
    let GetJobWithEmployer = "Job/GetJobWithEmployer"
    let GetAllIndustries = "Job/GetAllIndustries"
    let GetAllJobSearch = "Job/GetAllJobSearch"
    let AddJobSearch = "Job/AddJobSearch"
    let SearchJobs = "Job/SearchJobs"
    let GetAllCandidateByJob = "Job/GetAllCandidateByJob"
    let GetEmployerById = "Job/GetEmployerById"
    let GetJobById = "Job/GetJobById"
    let GetJobWithEmployers = "Job/GetJobWithEmployers"
    let DeleteJobFormSearch = "Job/DeleteJobFormSearch"
    let MatchOrPassUser = "MatchOrPass/MatchOrPassUser"
    let UpdateJob = "Job/UpdateJob"

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
        request.addValue(self.getAccessToken(), forHTTPHeaderField: "Authorization")

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
    
    func postRequestApi(parameters : [String: Any] ,api : String , completion: @escaping (Data?, Error?) -> Void) {
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
        request.addValue(self.getAccessToken(), forHTTPHeaderField: "Authorization")

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

            
                SwiftLoader.hide()
                completion(data, nil)
            
        })

        task.resume()
    }
    func getAccessToken() -> String {
           if let accessToken =  UserDefaults.standard.value(forKey: "accessToken") as? String {
               print(accessToken)
               return "Bearer " + accessToken
           } else {
               return ""
           }
       }
    func getRequest(api : String ,showLoader : Bool? = true, completion: @escaping ([String : Any]?, Error? ) -> Void) {
        let urlString =  baseURL +  api
        print(urlString)

        if showLoader == true
        {
            SwiftLoader.show(animated: true)
        }

        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET" //set http method as POST
            //HTTP Headers
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
           request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue(self.getAccessToken(), forHTTPHeaderField: "Authorization")


            URLSession.shared.dataTask(with: request) {data, res, error in
                guard error == nil else {
                    if showLoader == true
                    {
                        SwiftLoader.hide()
                    }
                    completion(nil, error)
                    return
                }

                guard let data = data else {
                    if showLoader == true
                    {
                        SwiftLoader.hide()
                    }
                    completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                    return
                }

                do {
                    //create json object from data
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                    print(json)
                        if showLoader == true
                        {
                            SwiftLoader.hide()
                        }
                    completion(json, nil)
                } catch let error {
                    if showLoader == true
                    {
                        SwiftLoader.hide()
                    }
                    print(error.localizedDescription)
                    completion(nil, error)
                }
            }.resume()
        }
    }
    func getRequestApi(api : String ,showLoader : Bool? = true, completion: @escaping (Data?, Error? ) -> Void) {
        let urlString =  baseURL +  api
        print(urlString)

        if showLoader == true
        {
            SwiftLoader.show(animated: true)
        }

        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET" //set http method as POST
            //HTTP Headers
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
           request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue(self.getAccessToken(), forHTTPHeaderField: "Authorization")


            URLSession.shared.dataTask(with: request) {data, res, error in
                guard error == nil else {
                    if showLoader == true
                    {
                        SwiftLoader.hide()
                    }
                    completion(nil, error)
                    return
                }

                guard let data = data else {
                    if showLoader == true
                    {
                        SwiftLoader.hide()
                    }
                    completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                    return
                }
                        if showLoader == true
                        {
                            SwiftLoader.hide()
                        }
                    completion(data, nil)
               
            }.resume()
        }
    }
    
}
