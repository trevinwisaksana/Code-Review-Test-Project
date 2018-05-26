//
//  StorageReference+Post.swift
//  Makestagram
//
//  Created by Trevin Wisaksana on 08/12/2017.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation
import FirebaseStorage

extension StorageReference {
    static let dateFormatter = ISO8601DateFormatter()
    
    static func newPostImageReference() -> StorageReference {
        let uid = User.current.uid
        let timestamp = dateFormatter.string(from: Date())
        
        return Storage.storage().reference().child("images/posts/\(uid)/\(timestamp).jpg")
    }
}
