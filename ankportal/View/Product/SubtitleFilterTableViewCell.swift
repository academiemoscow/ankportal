//
//  FilterTableViewCell.swift
//  ankportal
//
//  Created by Admin on 04/06/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class SubtitleFilterTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ClickableFilterTableViewCell: SubtitleFilterTableViewCell {
    
    weak var filterItem: FilterItem?
    
    class var rowHeight: CGFloat {
        return 50
    }
    
    func didSelect(_ target: FiltersTableViewController, cellRowAtIndexPath indexPath: IndexPath) {
    }
    
    func configureCell(forModel model: FilterItem) {
        filterItem = model
    }
}

class BrandSelectTableViewCell: ClickableFilterTableViewCell {
    override func didSelect(_ target: FiltersTableViewController, cellRowAtIndexPath indexPath: IndexPath) {
        let vc = BrandListTableViewController()
        let brandFilter = target.getData(forRowAt: indexPath)
        var selectedItems: [ANKPortalItemSelectable] = []
        brandFilter.values.forEach { (restParameter) in
            if let ankportalItem = (restParameter as? RESTParameterANKPortalItem)?.ankportalItem {
                selectedItems.append(ankportalItem)
            }
        }
        vc.dataSelected = selectedItems
        vc.onDoneCallback = { [weak target] (selectedData) in
            let restFilterType = brandFilter.restFilters[0]
            let ids = selectedData.map({ (item) -> RESTParameterANKPortalItem in
                let restParameter = RESTParameterANKPortalItem(filter: restFilterType, value: item.id!)
                restParameter.description = item.name!
                restParameter.ankportalItem = item
                return restParameter
            })
            brandFilter.removeAllValues()
            brandFilter.add(values: ids)
            DispatchQueue.main.async {
                target?.tableView.reloadData()
            }
        }
        target.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func configureCell(forModel model: FilterItem) {
        super.configureCell(forModel: model)
        textLabel?.text = model.name
        detailTextLabel?.text = model.getDescription()
        imageView?.image = UIImage(named: "apply_icon")?.flip(toOrientation: .left, withScale: 2.0)
    }
}

class LineSelectTableViewCell: ClickableFilterTableViewCell {
    override func didSelect(_ target: FiltersTableViewController, cellRowAtIndexPath indexPath: IndexPath) {
        print("select")
    }
    override func configureCell(forModel model: FilterItem) {
        super.configureCell(forModel: model)
        textLabel?.text = model.name
        detailTextLabel?.text = model.getDescription()
        imageView?.image = UIImage(named: "apply_icon")?.flip(toOrientation: .left, withScale: 2.0)
    }
}
