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
let googleApiKey = "AIzaSyAsJukxWTJLy-q1CD2DJmeDNOCejHp8xuk"
let baseURL = "http://34.207.158.183/api/v1.0/"

var experienceArray = ExperienceLevel.allCases.map { $0.rawValue }
var jobArray = JobType.allCases.map { $0.rawValue }
var companyArray = CompanySize.allCases.map { $0.rawValue }
var languageArray = LanguageLevel.allCases.map { $0.rawValue }
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

enum CompanySize: String ,CaseIterable{
    case micro = "1-4 workers"
    case small = "5 – 19 workers"
    case medium = "20 – 99 workers"
    case large = "100 and more workers"

    var id: Int {
        switch self{
        case .micro : return 0
        case .small : return 1
        case .medium  : return 2
        case .large : return 3
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

enum LanguageLevel: String ,CaseIterable{
    case notSelected = "Not Selected"
    case beginner = "Beginner"
    case preIntermediate = "Pre Intermediate"
    case Intermediate = "Intermediate"
    case UpperIntermediate = "Upper Intermediate"
    case Advanced = "Advanced"
    case Fluent = "Fluent"

    var id: Int {
        switch self{
        case .notSelected : return 0
        case .beginner : return 1
        case .preIntermediate  : return 2
        case .Intermediate : return 3
        case .UpperIntermediate : return 4
        case .Advanced : return 5
        case .Fluent : return 6

        default: return 0
        }
    }
}
