//
//  StorageManager.swift
//  Instgraam
//
//  Created by sa3doola on 8/24/20.
//  Copyright © 2020 saad sherif. All rights reserved.
//

import FirebaseStorage

public class StorageManager {
    
    static let shared = StorageManager()
    
    private let bucket = Storage.storage().reference()
    
    public enum IGStorageManagerError: Error {
        case faileToDownload
    }
    
    public func uploadUserPost(model: UserPost, completion: @escaping ((Result<URL, Error>) -> Void)) {
        
    }
    
    public func downloadImage(reference: String, completion: @escaping (Result<URL, IGStorageManagerError>) -> Void) {
        bucket.child(reference).downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(.faileToDownload))
                return
            }
            completion(.success(url))
        })
    }
}

