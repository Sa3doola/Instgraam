//
//  SettingsVC.swift
//  Instgraam
//
//  Created by sa3doola on 8/24/20.
//  Copyright © 2020 saad sherif. All rights reserved.
//

import SafariServices
import UIKit

struct settingCellModel {
    let title: String
    let handler: (() -> Void)
}

/// View Controller to show user settings
final class SettingsVC: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var data = [[settingCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        addSubView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModels() {
        
        data.append([
            settingCellModel.init(title: "Edit Profile") { [weak self ] in
                self?.didTapEditProfile()
            },
            settingCellModel.init(title: "Invite Friends") { [weak self ] in
                self?.didTapInviteFriendds()
            },
            settingCellModel.init(title: "Save Original Posts") { [weak self ] in
                self?.didTapSaveOriginalPosts()
            }
        ])
        
        data.append([
            settingCellModel.init(title: "Term of Service") { [weak self ] in
                self?.openURL(type: .term)
            },
            settingCellModel.init(title: "Privacy Policy") { [weak self ] in
                self?.openURL(type: .privacy)
            },
            settingCellModel.init(title: "Help / Feedback") { [weak self ] in
                self?.openURL(type: .help)
            }
        ])
        
        data.append([
            
            settingCellModel.init(title: "Log Out") { [weak self ] in
                self?.didTapLogOut()
            }
        ])
        
        
    }
    
    private func addSubView() {
        view.addSubview(tableView)
    }
    
    private func didTapEditProfile() {
        let vc = EditProfileVC()
        vc.title = "Edit Profile"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    private func didTapInviteFriendds() {
        // Show invite sheet to invite firends
        
    }
    
    private func didTapSaveOriginalPosts() {
        
    }
    
    enum SettingURLType {
        case term, privacy , help
    }
    
    private func openURL(type: SettingURLType) {
        
        let urlString: String
        switch type {
        case .term: urlString = "https://help.instagram.com/581066165581870"
        case .privacy: urlString = "https://help.instagram.com/519522125107875"
        case .help: urlString = "https://help.instagram.com/"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    
    
    
    
    
    
    private func didTapLogOut() {
        let actionSheet = UIAlertController(title: "Log out",
                                            message: "Are you sure you want to log out?",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            AuthManager.shared.logOut(completion: { success in
                DispatchQueue.main.async {
                    if success {
                        // present loginVC
                        let loginVC = LoginVC()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true) {
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
                        
                    }
                    else {
                        // error occurred
                        fatalError("Could not log out user")
                    }
                }
            })
        }))
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        present(actionSheet, animated: true)
    }
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.section][indexPath.row].handler()
    }
    
    
}
