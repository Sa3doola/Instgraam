//
//  ExploreVC.swift
//  Instgraam
//
//  Created by sa3doola on 8/24/20.
//  Copyright © 2020 saad sherif. All rights reserved.
//

import UIKit

class ExploreVC: UIViewController {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = .secondarySystemBackground
        return searchBar
    }()
    
    private var models = [UserPost]()
    
    private var collectionView: UICollectionView?
    
    private var tappedSearchCollectionView: UICollectionView?
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isHidden = true
        view.alpha = 0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureSearchBar()
        configureExploreCollection()
        configureDimmedView()
        configureTabbedSearch()
    }
    
    private func configureTabbedSearch() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.width/3, height: 52)
        layout.scrollDirection = .horizontal
        tappedSearchCollectionView = UICollectionView(frame: .zero,
                                                      collectionViewLayout: layout)
        tappedSearchCollectionView?.backgroundColor = .yellow
        tappedSearchCollectionView?.isHidden = true
        guard let tappedSearchCollectionView = tappedSearchCollectionView else {
            return
        }
        tappedSearchCollectionView.delegate = self
        tappedSearchCollectionView.dataSource = self
        view.addSubview(tappedSearchCollectionView)
    }
    
    private func configureDimmedView() {
        view.addSubview(dimmedView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didCancelSearch))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        dimmedView.addGestureRecognizer(gesture)
    }
    
    private func configureSearchBar() {
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.delegate = self
    }
    
    private func configureExploreCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (view.width-4)/3, height: (view.width-4)/3)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(PhotoCollectionViewCell.self,
                                 forCellWithReuseIdentifier: PhotoCollectionViewCell.Id)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        dimmedView.frame = view.bounds
        tappedSearchCollectionView?.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: 75
        )
    }
}

extension ExploreVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        didCancelSearch()
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        query(text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didCancelSearch)
        )
        
        dimmedView.isHidden = false
        UIView.animate(withDuration: 0.2, animations:  {
            self.dimmedView.alpha = 0.4
        }) { done in
            if done {
                self.tappedSearchCollectionView?.isHidden = false
            }
        }
    }
    
    @objc private func didCancelSearch() {
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        self.tappedSearchCollectionView?.isHidden = true
        UIView.animate(withDuration: 0.2, animations: {
            self.dimmedView.alpha = 0
        }) { done in
            if done {
                self.dimmedView.isHidden = true
            }
        }
    }
    
    private func query(_ text: String) {
        // perform the search in the back end
    }
}

extension ExploreVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tappedSearchCollectionView {
            return 0
        }
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tappedSearchCollectionView {
            return UICollectionViewCell()
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.Id, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell()}
        cell.configure(with: "test")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView == tappedSearchCollectionView {
            // change search context
            return
        }
        let user = User(
            username: "@Sa3doola",
            bio: "Ios developer",
            name: (first: "", last: ""),
            profilePicture: URL(string: "https://www.google.com")!,
            birthDate: Date(),
            gender: .male,
            counts: UserCount(followers: 22, following: 22, posts: 22),
            joinDate: Date()
        )
        
        let post = UserPost(
            identifier: "",
            posttype: .photo,
            thumbnailImage: URL(string: "https://www.google.com")!,
            postURL: URL(string: "https://www.google.com")!,
            caption: "edeny w ana adya3",
            likeCount: [],
            comment: [],
            createdDate: Date(),
            taggedUser: [],
            owner: user
        )
        // let model = models[indexPath.row]
        let vc = PostVC(model: post)
        vc.title = post.posttype.rawValue
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
