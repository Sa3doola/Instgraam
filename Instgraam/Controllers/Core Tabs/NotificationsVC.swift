//
//  NotificationsVC.swift
//  Instgraam
//
//  Created by sa3doola on 8/24/20.
//  Copyright © 2020 saad sherif. All rights reserved.
//

import UIKit

enum UserNotificationType {
    case like(post: UserPost)
    case follow(state: followState)
}

struct UserNotification {
    let type: UserNotificationType
    let text: String
    let user: User
}

final class NotificationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = false
        tableView.register(NotificationLikeEventTVC.self,
                           forCellReuseIdentifier: NotificationLikeEventTVC.id)
        tableView.register(NotificationFollowEventTVC.self,
                           forCellReuseIdentifier: NotificationFollowEventTVC.id)
        
        
        return tableView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.tintColor = .label
        return spinner
    }()
    
    private lazy var noNotificatonView = noNotificationsView()
    
    private var models = [UserNotification]()
    
    // MARK: - Lifecycle
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotifications()
        navigationItem.title = "Notifications"
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(spinner)
        // spinner.startAnimating()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    private func fetchNotifications() {
        for x in 0...100 {
            let user = User(username: "sa3doola",
                            bio: "Ios deve;oper",
                            name: (first: "", last: ""),
                            profilePicture: URL(string: "https://www.google.com")!,
                            birthDate: Date(),
                            gender: .male,
                            counts: UserCount(followers: 22, following: 22, posts: 22),
                            joinDate: Date())
            
            let post = UserPost(identifier: "",
                                posttype: .photo,
                                thumbnailImage: URL(string: "https://www.google.com")!,
                                postURL: URL(string: "https://www.google.com")!,
                                caption: "edeny w ana adya3",
                                likeCount: [],
                                comment: [],
                                createdDate: Date(),
                                taggedUser: [],
                                owner: user)
            let model = UserNotification(type: x % 2 == 0 ? .like(post: post) : .follow(state: .not_following),
                                         text: "Hello world",
                                         user: user)
            models.append(model)
        }
    }
    
    private func addNoNotificationView() {
        tableView.isHidden = true
        noNotificatonView.frame = CGRect(x: 0, y: 0, width: view.width/2, height: view.width/4)
        noNotificatonView.center = view.center
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        switch model.type {
        case .follow:
            // follow cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationFollowEventTVC.id,
                                                     for: indexPath) as! NotificationFollowEventTVC
            //  cell.configure(with: model)
            cell.delegate = self
            return cell
        case .like(_):
            // like cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationLikeEventTVC.id,
                                                     for: indexPath) as! NotificationLikeEventTVC
            cell.configure(with: model)
            cell.delegate = self
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension NotificationsVC: NotificationLikeEventTVCDelegate, NotificationFollowEventTVCDelegate {
    func didTapFollowUnfollowButton(model: UserNotification) {
        print("Tapped button")
        // Perform database update
    }
    
    func didTapRelatedPostButton(model: UserNotification) {
        switch model.type {
        case .like(let post):
            let vc = PostVC(model: post)
            vc.title = post.posttype.rawValue
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .follow(_):
            fatalError("Dev Issue: Should never called")
        }
        // open the post
        
    }
}
