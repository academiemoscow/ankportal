//
//  ChatLogChatBallonCellCollectionViewCell.swift
//  ankportal
//
//  Created by Admin on 22/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class ChatLogChatBallonCellCollectionViewCell: UICollectionViewCell {
    
    lazy var textLabel: UITextView = {
        let label = UITextView()
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isScrollEnabled = false
        return label
    }()
    
    lazy var timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.gray
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var timestamp: Double? {
        didSet {
            if let timestamp = self.timestamp {
                let formatter = DateFormatter()
                let date = Date(timeIntervalSince1970: timestamp)
                formatter.dateFormat = "dd/MM/yyyy HH:mm"
                
                if Calendar.current.compare(Date(), to: date, toGranularity: .day) == .orderedSame {
                    formatter.dateFormat = "HH:mm"
                }
                
                self.timestampLabel.text = formatter.string(from: date)
            }
        }
    }
    
    lazy var timestampRightAnchor: NSLayoutConstraint = {
        let constraint = timestampLabel.rightAnchor.constraint(equalTo: bgView.leftAnchor, constant: -5)
        return constraint
    }()
    
    lazy var timestampLeftAnchor: NSLayoutConstraint = {
        let constraint = timestampLabel.leftAnchor.constraint(equalTo: bgView.rightAnchor, constant: 5)
        return constraint
    }()

    lazy var bgView: UIView = {
        let bv = UIView()
        bv.backgroundColor = UIColor.ballonBlue
        bv.layer.cornerRadius = 16
        bv.translatesAutoresizingMaskIntoConstraints = false
        return bv
    }()

    lazy var viewWidthAnchor: NSLayoutConstraint = {
        let constraint = bgView.widthAnchor.constraint(equalToConstant: 200)
        return constraint
    }()
    
    lazy var viewLeftAnchor: NSLayoutConstraint = {
        let safeLayoutGuide = self.safeAreaLayoutGuide
        let constraint = bgView.leftAnchor.constraint(equalTo: safeLayoutGuide.leftAnchor, constant: 8)
        return constraint
    }()
    
    lazy var viewRightAnchor: NSLayoutConstraint = {
        let safeLayoutGuide = self.safeAreaLayoutGuide
        let constraint = bgView.rightAnchor.constraint(equalTo: safeLayoutGuide.rightAnchor, constant: -8)
        return constraint
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func toLeftSide() {
        NSLayoutConstraint.deactivate([self.viewRightAnchor])
        NSLayoutConstraint.activate([self.viewLeftAnchor])
        
        bgView.backgroundColor = UIColor.ballonGrey
        textLabel.textColor = UIColor.black
        timestampLabel.textColor = UIColor.gray
        
        NSLayoutConstraint.deactivate([self.timestampRightAnchor])
        NSLayoutConstraint.activate([self.timestampLeftAnchor])
    }
    
    func toRightSide() {
        NSLayoutConstraint.deactivate([self.viewLeftAnchor])
        NSLayoutConstraint.activate([self.viewRightAnchor])
        
        bgView.backgroundColor = UIColor.ballonBlue
        textLabel.textColor = UIColor.white
        timestampLabel.textColor = UIColor.darkGray
        
        NSLayoutConstraint.deactivate([self.timestampLeftAnchor])
        NSLayoutConstraint.activate([self.timestampRightAnchor])
    }
    
    private func setupView() {
        
        addSubview(bgView)
        bgView.addSubview(textLabel)
        bgView.addSubview(timestampLabel)
        
        self.viewRightAnchor.isActive = true
        self.viewLeftAnchor.isActive = false
        self.viewWidthAnchor.isActive = true
        bgView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -25).isActive = true
        bgView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        textLabel.widthAnchor.constraint(equalTo: bgView.widthAnchor, constant: -8).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: bgView.centerYAnchor).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
        
        timestampLabel.bottomAnchor.constraint(equalTo: bgView.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
