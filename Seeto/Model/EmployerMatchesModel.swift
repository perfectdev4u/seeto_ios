// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let employerMatchesModel = try? JSONDecoder().decode(EmployerMatchesModel.self, from: jsonData)

import Foundation

// MARK: - EmployerMatchesModel
struct EmployerMatchesModel: Codable {
    let errors: Errors
    let data: [Datum]
    let returnStatus: Bool
    let statusCode: Int
    let returnMessage: [JSONAny]
    let responseMessage: JSONNull?
}

// MARK: - Datum
struct Datum: Codable {
    let jobID: Int
    let position: String
    let experienceLevel, jobType, jobLocation: Int
    let location: String?
    let minSalary, maxSalary: Int
    let videoURL, thumbnailURL: String?

    enum CodingKeys: String, CodingKey {
        case jobID = "jobId"
        case position, experienceLevel, jobType, jobLocation, location, minSalary, maxSalary
        case videoURL = "videoUrl"
        case thumbnailURL = "thumbnailUrl"
    }
}

