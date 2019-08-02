//
//  ParalaxHeaderTableView.swift
//  ankportal
//
//  Created by Admin on 02/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class ParalaxHeaderTableView: UITableView {
    
    private var headerBottomConstraint: NSLayoutConstraint!
    private var headerHeightConstraint: NSLayoutConstraint!
    
    var headerView: UIView
    
    var headerHeight: CGFloat = 200 {
        didSet {
            headerView.removeConstraints([
                headerBottomConstraint,
                headerHeightConstraint
            ])
            setupHeaderView()
        }
    }
    
    convenience init(headerView: UIView) {
        self.init(headerView: headerView, style: .plain)
    }
    
    init(headerView: UIView, style: UITableView.Style) {
        self.headerView = headerView
        super.init(frame: .zero, style: style)
        setupHeaderView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func paralaxHeaderTableView(withImageNamed named: String) -> ParalaxHeaderTableView {
        let imageView = UIImageView(image: UIImage(named: named))
        imageView.contentMode = .scaleAspectFill
        return ParalaxHeaderTableView(headerView: imageView)
    }
    
    private func setupHeaderView() {
        tableHeaderView = UIView(frame: CGRect(
            x: .zero,
            y: .zero,
            width: .zero,
            height: headerHeight
        ))
        setupInnerView()
    }
    
    private func setupInnerView() {
        tableHeaderView?.removeAllSubviews()
        tableHeaderView?.addSubview(headerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: tableHeaderView!.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: tableHeaderView!.trailingAnchor).isActive = true
        
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: headerHeight)
        headerHeightConstraint.isActive = true
        
        headerBottomConstraint = headerView.bottomAnchor.constraint(equalTo: tableHeaderView!.bottomAnchor)
        headerBottomConstraint.isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let offsetY = -contentOffset.y
        headerHeightConstraint.constant = max(
            headerHeight,
            headerHeight + offsetY
        )
        headerBottomConstraint.constant = offsetY >= 0 ? 0 : -offsetY / 2
        tableHeaderView?.clipsToBounds = offsetY <= 0
    }
    
    
    
}
