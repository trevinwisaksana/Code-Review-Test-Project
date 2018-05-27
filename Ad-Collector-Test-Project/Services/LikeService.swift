//
//  LikeService.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import Firebase

struct LikeService {
    
    let databaseReference = Database.database().reference()
    let currentUID = User.current.uid
    
    func create(for ad: Advertisement, success: @escaping (Bool) -> Void) {
        let likesRef = databaseReference.child("postLikes").child(ad.key).child(currentUID)

        likesRef.setValue(true) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
        }
    }


    func delete(for ad: Advertisement, success: @escaping (Bool) -> Void) {
        let likesRef = DatabaseReference.toLocation(.likes(postKey: ad.key, currentUID: currentUID))
        
        likesRef.setValue(nil) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
        }
    }


    func isPostLiked(_ ad: Advertisement, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        
        let likesRef = DatabaseReference.toLocation(.isLiked(postKey: ad.key))

        likesRef.queryEqual(toValue: nil, childKey: User.current.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String : Bool] {
                completion(true)
            } else {
                completion(false)
            }
        })
    }


    func setIsLiked(_ isLiked: Bool, for ad: Advertisement, success: @escaping (Bool) -> Void) {
        if isLiked {
            create(for: ad, success: success)
        } else {
            delete(for: ad, success: success)
        }
    }
    
}
