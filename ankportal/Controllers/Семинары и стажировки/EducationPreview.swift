//
//  EducationPreview.swift
//  ankportal
//
//  Created by Олег Рачков on 10/09/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation

struct EducationPreview: Codable {
    
    var id: String?
    var name: String?
    var date: String?
    var town: String?
    var time: String?
    var type: [String]?
    var doctorInfo: [DoctorInfo]?
    
    struct DoctorInfo: Codable {
        var id: String?
        var doctorLastName: String?
        var doctorName: String?
        var doctorSecondName: String?
        var workPosition: String?
        var workProfile: String?
        var photoURL: String?
 
        enum CodingKeys: String, CodingKey {
            case id = "ID"
            case doctorLastName = "LAST_NAME"
            case doctorName = "NAME"
            case doctorSecondName = "SECOND_NAME"
            case workPosition = "WORK_POSITION"
            case workProfile = "WORK_PROFILE"
            case photoURL = "PHOTO"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "NAME"
        case date = "DATE_START"
        case town = "TOWN"
        case time = "TIME"
        case type = "TYPE"
        case doctorInfo = "TRAINERS"
    }
    
}

class EducationInfoCell {
    var educationInfoFromJSON: EducationPreview!
    enum CellSide {
        case name
        case trainer
    }
    var side: CellSide = .name
}
