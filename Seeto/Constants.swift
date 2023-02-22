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

var experienceArray = [DropdownModel(val: "Not Selected", id: 0),DropdownModel(val: "Entry Level", id: 1),DropdownModel(val: "Internship", id: 2),DropdownModel(val: "Associate", id: 3),DropdownModel(val: "Mid Senior", id: 4),DropdownModel(val: "Director", id: 5),DropdownModel(val: "Executive", id: 6)]

struct DropdownModel
{
   let val : String
   let id : Int
}
