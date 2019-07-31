//
//  SectionsListTableViewController.swift
//  ankportal
//
//  Created by Admin on 30/07/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class SectionsListTableViewController: BrandListTableViewController {
    
    var selectedBrandsID: [String] = []
    
    override func fetchData() {
        status = .Loading
        ANKPortalCatalogs.sections.getAll {[weak self] (items, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.status = .LoadError
                    self?.activityIndicatorLabel.text = error.localizedDescription
                }
                return
            }
            
            self?.updateData(withFetched: self?.dataFilter(items) ?? items)
        }
    }
    
}
