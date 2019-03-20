//
//  EducationDetailedInfoController.swift
//  ankportal
//
//  Created by Олег Рачков on 19/03/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class EducationDetailedInfoController: UIViewController {
    var educationId: String?
    var educationName: String?
    var educationCity: String?
    var educationDate: String?
    var doctorName: String?
    var doctorPhoto: UIImage?
    var doctorRegaly: String?
    
    var educationNameLabel: UILabel = {
        var educationNameLabel = UILabel()
        educationNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        educationNameLabel.numberOfLines = 5
        educationNameLabel.backgroundColor = UIColor.init(white: 1, alpha: 1)
        educationNameLabel.textAlignment = NSTextAlignment.left
        educationNameLabel.sizeToFit()
        educationNameLabel.layer.masksToBounds = true
        educationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return educationNameLabel
    }()
    
    var educationDateTextLabel: UILabel = {
        var educationDateTextLabel = UILabel()
        educationDateTextLabel.font = UIFont.boldSystemFont(ofSize: 18)
        educationDateTextLabel.numberOfLines = 1
        educationDateTextLabel.backgroundColor = UIColor(white: 1, alpha: 1)
        educationDateTextLabel.textAlignment = NSTextAlignment.center
        educationDateTextLabel.sizeToFit()
        educationDateTextLabel.layer.masksToBounds = true
        educationDateTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return educationDateTextLabel
    }()
    
    var educationNameTextLabel: UILabel = {
        var educationNameTextLabel = UILabel()
        educationNameTextLabel.font = UIFont.systemFont(ofSize: 14)
        educationNameTextLabel.numberOfLines = 5
        educationNameTextLabel.backgroundColor = UIColor(white: 1, alpha: 1)
        educationNameTextLabel.textAlignment = NSTextAlignment.center
        educationNameTextLabel.sizeToFit()
        educationNameTextLabel.layer.masksToBounds = true
        educationNameTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return educationNameTextLabel
    }()
    
    
    
}
