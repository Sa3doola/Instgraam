//
//  Models.swift
//  Instgraam
//
//  Created by sa3doola on 8/27/20.
//  Copyright © 2020 saad sherif. All rights reserved.
//

import Foundation

enum Gender {
    case male, female
}

struct User {
    let username: String
    let bio: String
    let name: (first: String, last: String)
    let profilePicture: URL
    let birthDate: Date
    let gender: Gender
    let counts: UserCount
    let joinDate: Date
}

struct UserCount {
    let followers: Int
    let following: Int
    let posts: Int
}


public enum UserPostType: String {
    case photo = "photo"
    case video = "video"
}

/// Represents a user post
public struct UserPost {
    let identifier: String
    let posttype: UserPostType
    let thumbnailImage: URL
    let postURL: URL // either video url pr full resolution photo
    let caption: String?
    let likeCount: [PostLike]
    let comment: [PostComment]
    let createdDate: Date
    let taggedUser: [String]
    let owner: User
}

struct PostLike {
    let username: String
    let postIdentifier: String
}

struct PostComment {
    let identifier: String
    let username: String
    let text: String
    let createdDate: Date
    let like: [CommentLike]
}

struct CommentLike {
    let username: String
    let commentIdentifier: String
}
