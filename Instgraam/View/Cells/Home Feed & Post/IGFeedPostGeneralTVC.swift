//
//  IGFeedPostGeneralTVC.swift
//  Instgraam
//
//  Created by sa3doola on 8/25/20.
//  Copyright © 2020 saad sherif. All rights reserved.
//

import UIKit

///Comments
class IGFeedPostGeneralTVC: UITableViewCell {
    
    static let id = "IGFeedPostGeneralTVC"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}
