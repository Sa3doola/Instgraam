//
//  PostVC.swift
//  Instgraam
//
//  Created by sa3doola on 8/24/20.
//  Copyright © 2020 saad sherif. All rights reserved.
//
import UIKit
/*
 Section
 - Header model
 Section
 - Post Cell model
 Section
 - Action Buttons cell model
 Section
 - n numbers of general models of comments
 */
/// States of a rendered cell
enum PostRenderType {
    case header(provider: User)
    case primaryContent(provider: UserPost) // Post
    case actions(provider: String) // like, comment, share
    case comments(comments: [PostComment])
}
/// Model of render post
struct PostRenderViewModel {
    let renderType: PostRenderType
}


class PostVC: UIViewController {
    
    private let model: UserPost?
    
    private var renderModel = [PostRenderViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        // Register Cell
        tableView.register(IGFeedPostTVC.self,
                           forCellReuseIdentifier: IGFeedPostTVC.id)
        tableView.register(IGFeedPostHeaderTVC.self,
                           forCellReuseIdentifier: IGFeedPostHeaderTVC.id)
        tableView.register(IGFeedPostActionTVC.self,
                           forCellReuseIdentifier: IGFeedPostActionTVC.id)
        tableView.register(IGFeedPostGeneralTVC.self,
                           forCellReuseIdentifier: IGFeedPostGeneralTVC.id)
        return tableView
    }()
    
    // MARK: - Init
    
    init(model: UserPost) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        configureModels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureModels() {
        guard let userPostModel = self.model else {
            return
        }
        // Headers
        renderModel.append(PostRenderViewModel.init(renderType: .header(provider: userPostModel.owner)))
        // Post
        renderModel.append(PostRenderViewModel.init(renderType: .primaryContent(provider: userPostModel)))
        // Actions
        renderModel.append(PostRenderViewModel.init(renderType: .actions(provider: "sa3doola")))
        // Comments
        var comments = [PostComment]()
        for x in 0..<4 {
            comments.append(
                PostComment.init(identifier: "123_\(x)",
                    username: "sa3doola",
                    text: "A5oya el gada3!😍",
                    createdDate: Date(),
                    like: []))
        }
        renderModel.append(PostRenderViewModel.init(renderType: .comments(comments: comments)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
}

extension PostVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return renderModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch renderModel[section].renderType {
        case .header(_): return 1
        case .primaryContent(_): return 1
        case .actions(_): return 1
        case .comments(let comments): return comments.count > 4 ? 4 : comments.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = renderModel[indexPath.section]
        
        switch model.renderType {
        case .header(let user):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTVC.id,
                                                     for: indexPath) as! IGFeedPostHeaderTVC
            cell.configure(with: user)
            cell.delegate = self
            return cell
        case .primaryContent(let post):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTVC.id,
                                                     for: indexPath) as! IGFeedPostTVC
            cell.configure(with: post)
            return cell
        case .actions(let action):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionTVC.id,
                                                     for: indexPath) as! IGFeedPostActionTVC
            cell.delegate = self
            return cell
        case .comments(let comments):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTVC.id,
                                                     for: indexPath) as! IGFeedPostGeneralTVC
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = renderModel[indexPath.section]
        
        switch model.renderType {
        case .header(_): return 50
        case .primaryContent(_): return tableView.width
        case .actions(_): return 50
        case .comments(_): return 50
        }
    }
}

extension PostVC: IGFeedPostHeaderTVCDelegate {
    
    func didTapMoreButton() {
        let actionSheet = UIAlertController(title: "Post Options", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Report...", style: .destructive, handler: { [weak self]_ in
            self?.reportPost()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    func reportPost() {
        
    }
}

extension PostVC: IGFeedPostActionTVCDelegate {
    
    func didTapLikeButton() {
        print("Like")
    }
    
    func didTapCommentButton() {
         print("Comment")
    }
    
    func didTapSendButton() {
         print("Send")
    }
    
    func didTapSavedButton() {
        print("Saved")
    }
    
    
}

