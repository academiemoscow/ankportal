//
//  ChatLogChatBallonCellCollectionViewCell.swift
//  ankportal
//
//  Created by Admin on 22/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit
import Firebase

class ChatLogChatBallonCellCollectionViewCell: UICollectionViewCell {
    
    var message: Message? {
        didSet {
            if (message?.fromId != Auth.auth().currentUser?.uid) {
                self.toLeftSide()
            } else {
                self.toRightSide()
                
                message?.onStatusChanged = { (newStatus) in
                    if newStatus.rawValue > 1 {
                        self.bgView.backgroundColor = UIColor.black
                    }
                }
            }
            
            if let timestamp = message?.timestamp {
                self.timestamp = Double(exactly: timestamp)
            }
            self.textLabel.text = message?.text
        }
    }
    
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
                formatter.dateFormat = "HH:mm"
                
                if Calendar.current.compare(Date(), to: date, toGranularity: .day) == .orderedSame {
                    formatter.dateFormat = "HH:mm"
                }
                
                self.timestampLabel.text = formatter.string(from: date)
            }
        }
    }
    
    lazy var timestampRightAnchor: NSLayoutConstraint = {
        let constraint = timestampLabel.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: -8)
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
    
    let padding: CGFloat = 8
    
    lazy var viewLeftAnchor: NSLayoutConstraint = {
        let safeLayoutGuide = self.safeAreaLayoutGuide
        let constraint = bgView.leftAnchor.constraint(equalTo: safeLayoutGuide.leftAnchor, constant: padding)
        return constraint
    }()
    
    lazy var viewRightAnchor: NSLayoutConstraint = {
        let safeLayoutGuide = self.safeAreaLayoutGuide
        let constraint = bgView.rightAnchor.constraint(equalTo: safeLayoutGuide.rightAnchor, constant: -padding)
        return constraint
    }()
    
    lazy var tapView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
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
        timestampLabel.textColor = UIColor.black
    }
    
    func toRightSide() {
        NSLayoutConstraint.deactivate([self.viewLeftAnchor])
        NSLayoutConstraint.activate([self.viewRightAnchor])
        
        bgView.backgroundColor = UIColor.ballonBlue
        textLabel.textColor = UIColor.white
        timestampLabel.textColor = UIColor.white
    }
    
    private func setupView() {
        
        addSubview(bgView)
        bgView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -10).isActive = true
        bgView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        self.viewRightAnchor.isActive = true
        self.viewLeftAnchor.isActive = false
        self.viewWidthAnchor.isActive = true
        
        bgView.addSubview(timestampLabel)
        bgView.addSubview(textLabel)
        textLabel.rightAnchor.constraint(equalTo: timestampLabel.leftAnchor, constant: -5).isActive = true
        textLabel.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 8).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: bgView.centerYAnchor).isActive = true
        self.timestampRightAnchor.isActive = true
        
        timestampLabel.bottomAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: -8).isActive = true
        
        bgView.addSubview(tapView)
        tapView.topAnchor.constraint(equalTo: bgView.topAnchor).isActive = true
        tapView.bottomAnchor.constraint(equalTo: bgView.bottomAnchor).isActive = true
        tapView.leftAnchor.constraint(equalTo: bgView.leftAnchor).isActive = true
        tapView.rightAnchor.constraint(equalTo: bgView.rightAnchor).isActive = true
    
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
