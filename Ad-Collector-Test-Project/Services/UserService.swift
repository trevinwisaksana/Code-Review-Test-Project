//
//  UserService.swift
//  Makestagram
//
//  Created by Trevin Wisaksana on 03/12/2017.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User

struct UserService {
    
    private let databaseReference = Database.database().reference()
    private lazy var currentUser = User.current
    private lazy var currentUID = User.current.uid
    
    func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": username]
        let uid = firUser.uid
        
        let ref = DatabaseReference.toLocation(.showUser(uid: uid))
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = DatabaseReference.toLocation(.showUser(uid: uid))
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(user)
        })
    }
    
//    func posts(for user: User, completion: @escaping ([Advertisement]) -> Void) {
//
//        let ref = DatabaseReference.toLocation(.ads(uid: user.uid))
//
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//
//            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
//                return completion([])
//            }
//
//            let dispatchGroup = DispatchGroup()
//
//            let ads: [Advertisement] = snapshot.reversed().compactMap {
//                guard let ad = Advertisement(snapshot: $0) else { return nil }
//                dispatchGroup.enter()
//
//                LikeService.isPostLiked(ad) { (isLiked) in
//                    ad.isLiked = isLiked
//                    dispatchGroup.leave()
//                }
//                return ad
//            }
//
//            dispatchGroup.notify(queue: .main, execute: {
//                completion(ads)
//            })
//        })
//
//    }
    
//    func modifyDataKeys() {
//        for i in 1...999 {
//            let ref = databaseReference.child("items").child("\(i)")
//
//            ref.observeSingleEvent(of: .value, with: { (snapshot) in
//
//                guard let snapshot = snapshot.value else {
//                    return
//                }
//
//                self.databaseReference.child("items").childByAutoId().setValue(snapshot)
//                ref.removeValue()
//            })
//        }
//    }
    
}
