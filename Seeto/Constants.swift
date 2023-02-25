//
//  Constants.swift
//  Seeto
//
//  Created by Paramveer Singh on 07/01/23.
//

import Foundation
import UIKit

let grayColor = UIColor.init(red: 0.565, green: 0.565, blue: 0.565, alpha: 1)
let blueButtonColor = UIColor.init(red: 0.004, green:0.769, blue: 0.996, alpha: 1)
let backGroundColor = UIColor.init(red: 0.153, green:0.153, blue: 0.153, alpha: 1)
let grayShadeColor = UIColor.init(red: 0.208, green:0.208, blue: 0.208, alpha: 1)

let darkShadeColor = UIColor.init(red: 0.110, green:0.110, blue: 0.110, alpha: 1)
let likeButtonBackGroundColor = UIColor.init(red: 0.145, green:0.212, blue: 0.231, alpha: 1)

let googleClientID = "72919610538-rhqe3h7lrovdsb254q3dg9kua4c6o0nm.apps.googleusercontent.com"

let baseURL = "http://34.207.158.183/api/v1.0/"

//var experienceArray = [DropdownModel(val: "Not Selected", id: 0),DropdownModel(val: "Entry Level", id: 1),DropdownModel(val: "Internship", id: 2),DropdownModel(val: "Associate", id: 3),DropdownModel(val: "Mid Senior", id: 4),DropdownModel(val: "Director", id: 5),DropdownModel(val: "Executive", id: 6)]

enum ExperienceLevel: String ,CaseIterable{
    case notSelected = "Not Selected"
    case entryLevel = "Entry Level"
    case internship = "Internship"
    case associate = "Associate"
    case midSenior =  "Mid Senior"
    case director = "Director"
    case executive = "Executive"
 
    var id: Int {
        switch self{
        case .notSelected : return 0
        case .entryLevel : return 1
        case .internship  : return 2
        case .associate : return 3
        case .midSenior : return 4
        case .director : return 5
        case .executive : return 6
        default: return 0
        }
    }
}
    

enum JobType: String ,CaseIterable{
    case notSelected = "Not Selected"
    case fullTime = "Full Time"
    case partTime = "Part Time"
    case contract = "Contract"
    case temporary =  "Temporary"
    case volunteer = "Volunteer"
    case internShip = "Internship"
    case other = "Other"

    var id: Int {
        switch self{
        case .notSelected : return 0
        case .fullTime : return 1
        case .partTime  : return 2
        case .contract : return 3
        case .temporary : return 4
        case .volunteer : return 5
        case .internShip : return 6
        case .other : return 7
        default: return 0
        }
    }
}

enum JobLocation: String ,CaseIterable{
    case notSelected = "Not Selected"
    case onSite = "On-Site"
    case remote = "Remote"
    case hybrid = "Hybrid"

    var id: Int {
        switch self{
        case .notSelected : return 0
        case .onSite : return 1
        case .remote  : return 2
        case .hybrid : return 3
        default: return 0
        }
    }
}
