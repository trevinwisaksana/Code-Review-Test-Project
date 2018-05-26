//
//  LikeService.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

class LikeService {
    
    func saveToFavorite(_ data: Advertisement?) {
        
        guard let data = data else {
            return
        }
        
        let newFavoriteAd = CoreDataHelper.newFavoriteAd()
        
        newFavoriteAd.isFavorite = true
        newFavoriteAd.location = data.location
        newFavoriteAd.photoURL = data.photoURL
        newFavoriteAd.title = data.title
        
        newFavoriteAd.price = Double(data.price)
        newFavoriteAd.key = data.key
        
        CoreDataHelper.save()
    }
    
    func remove(_ data: FavoriteAd) {
        if let key = data.key {
            UserDefaults.standard.removeObject(forKey: "\(key)")
            CoreDataHelper.delete(ad: data)
            CoreDataHelper.save()
        }
    }
    
    //    private static let databaseReference = Database.database().reference()
    //
    //    static func create(for post: Post, success: @escaping (Bool) -> Void) {
    //
    //        guard let key = post.key else {
    //            return success(false)
    //        }
    //
    //        let currentUID = User.current.uid
    //
    //        let likesRef = databaseReference.child("postLikes").child(key).child(currentUID)
    //        likesRef.setValue(true) { (error, _) in
    //            if let error = error {
    //                assertionFailure(error.localizedDescription)
    //                return success(false)
    //            }
    //
    //            let likeCountRef = databaseReference.child("posts").child(post.poster.uid).child(key).child("like_count")
    //
    //            likeCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
    //                let currentCount = mutableData.value as? Int ?? 0
    //
    //                mutableData.value = currentCount + 1
    //
    //                return TransactionResult.success(withValue: mutableData)
    //            }, andCompletionBlock: { (error, _, _) in
    //                if let error = error {
    //                    assertionFailure(error.localizedDescription)
    //                    success(false)
    //                } else {
    //                    success(true)
    //                }
    //            })
    //        }
    //    }
    //
    //
    //    static func delete(for post: Post, success: @escaping (Bool) -> Void) {
    //        guard let key = post.key else {
    //            return success(false)
    //        }
    //
    //        let currentUID = User.current.uid
    //
    //        let likesRef = DatabaseReference.toLocation(.likes(postKey: key, currentUID: currentUID))
    //        likesRef.setValue(nil) { (error, _) in
    //            if let error = error {
    //                assertionFailure(error.localizedDescription)
    //                return success(false)
    //            }
    //
    //            let likeCountRef = DatabaseReference.toLocation(.likesCount(posterUID: currentUID, postKey: key))
    //
    //            likeCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
    //                let currentCount = mutableData.value as? Int ?? 0
    //
    //                mutableData.value = currentCount - 1
    //
    //                return TransactionResult.success(withValue: mutableData)
    //
    //            }, andCompletionBlock: { (error, _, _) in
    //                if let error = error {
    //                    assertionFailure(error.localizedDescription)
    //                    success(false)
    //                } else {
    //                    success(true)
    //                }
    //            })
    //        }
    //    }
    //
    //
    //    static func isPostLiked(_ post: Post, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
    //
    //        guard let postKey = post.key else {
    //            assertionFailure("Error: post must have key.")
    //            return completion(false)
    //        }
    //
    //        let likesRef = DatabaseReference.toLocation(.isLiked(postKey: postKey))
    //
    //        likesRef.queryEqual(toValue: nil, childKey: User.current.uid).observeSingleEvent(of: .value, with: { (snapshot) in
    //            if let _ = snapshot.value as? [String : Bool] {
    //                completion(true)
    //            } else {
    //                completion(false)
    //            }
    //        })
    //    }
    //
    //
    //    static func setIsLiked(_ isLiked: Bool, for post: Post, success: @escaping (Bool) -> Void) {
    //        if isLiked {
    //            create(for: post, success: success)
    //        } else {
    //            delete(for: post, success: success)
    //        }
    //    }
    
}
