//
//  IGFeedPostHeaderTVC.swift
//  Instgraam
//
//  Created by sa3doola on 8/25/20.
//  Copyright © 2020 saad sherif. All rights reserved.
//

import SDWebImage
import UIKit

protocol IGFeedPostHeaderTVCDelegate: AnyObject {
    func didTapMoreButton()
}

class IGFeedPostHeaderTVC: UITableViewCell {
    
    public weak var delegate: IGFeedPostHeaderTVCDelegate?
    
    static let id = "IGFeedPostHeaderTVC"
    
    private let profilePhotoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let moreButton: UIButton = {
       let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profilePhotoImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(moreButton)
        moreButton.addTarget(self,
                             action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapButton() {
        delegate?.didTapMoreButton()
    }
    
    public func configure(with model: User) {
        userNameLabel.text = model.username
        profilePhotoImageView.image = UIImage(named: "test")
       // profilePhotoImageView.sd_setImage(with: model.profilePicture, completed: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = contentView.height - 6
        profilePhotoImageView.frame = CGRect(x: 2, y: 2, width: size, height: size)
        profilePhotoImageView.layer.cornerRadius = size / 2
        userNameLabel.frame = CGRect(x: profilePhotoImageView.right + 10,
                                     y: 2,
                                     width: contentView.width - (size * 2) - 15,
                                     height: contentView.height - 4)
        moreButton.frame = CGRect(x: contentView.width - size, y: 2, width: size, height: size)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userNameLabel.text = nil
        profilePhotoImageView.image = nil
    }
}
