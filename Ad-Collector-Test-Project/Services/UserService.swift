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
    
//    private static let databaseReference = Database.database().reference()
//    private static let currentUser = User.current
//    private static let currentUID = currentUser.uid
//    
//    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
//        let userAttrs = ["username": username]
//        let uid = firUser.uid
//        
//        let ref = DatabaseReference.toLocation(.showUser(uid: uid))
//        ref.setValue(userAttrs) { (error, ref) in
//            if let error = error {
//                assertionFailure(error.localizedDescription)
//                return completion(nil)
//            }
//            
//            ref.observeSingleEvent(of: .value, with: { (snapshot) in
//                let user = User(snapshot: snapshot)
//                completion(user)
//            })
//        }
//    }
//    
//    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
//        let ref = DatabaseReference.toLocation(.showUser(uid: uid))
//        
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            guard let user = User(snapshot: snapshot) else {
//                return completion(nil)
//            }
//            
//            completion(user)
//        })
//    }
//    
//    static func posts(for user: User, completion: @escaping ([Post]) -> Void) {
//        let ref = DatabaseReference.toLocation(.posts(uid: user.uid))
//        
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
//                return completion([])
//            }
//            
//            let dispatchGroup = DispatchGroup()
//            
//            let posts: [Post] = snapshot.reversed().compactMap {
//                guard let post = Post(snapshot: $0) else { return nil }
//                dispatchGroup.enter()
//                
//                LikeService.isPostLiked(post) { (isLiked) in
//                    post.isLiked = isLiked
//                    dispatchGroup.leave()
//                }
//                return post
//            }
//            
//            dispatchGroup.notify(queue: .main, execute: {
//                completion(posts)
//            })
//        })
//    }
//    
//    static func usersExcludingCurrentUser(completion: @escaping ([User]) -> Void) {
//        
//        let ref = DatabaseReference.toLocation(.users)
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
//                else { return completion([]) }
//            
//            let users = snapshot.compactMap(User.init).filter {
//                $0.uid != currentUser.uid
//            }
//            
//            let dispatchGroup = DispatchGroup()
//            users.forEach { (user) in
//                dispatchGroup.enter()
//                
//                FollowService.isUserFollowed(user) { (isFollowed) in
//                    user.isFollowed = isFollowed
//                    dispatchGroup.leave()
//                }
//            }
//            
//            dispatchGroup.notify(queue: .main, execute: {
//                completion(users)
//            })
//        })
//    }
//    
//    static func followers(for user: User, completion: @escaping ([String]) -> Void) {
//        let followersRef = DatabaseReference.toLocation(.followers(uid: currentUID))
//        
//        followersRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            guard let followersDict = snapshot.value as? [String : Bool] else {
//                return completion([])
//            }
//            
//            let followersKeys = Array(followersDict.keys)
//            completion(followersKeys)
//        })
//    }
//    
//    static func timeline(pageSize: UInt, lastPostKey: String? = nil, completion: @escaping ([Post]) -> Void) {
//        
//        let ref = DatabaseReference.toLocation(.timeline(uid: currentUID))
//        var query = ref.queryOrderedByKey().queryLimited(toLast: pageSize)
//        if let lastPostKey = lastPostKey {
//            query = query.queryEnding(atValue: lastPostKey)
//        }
//        
//        query.observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
//                else { return completion([]) }
//            
//            let dispatchGroup = DispatchGroup()
//            
//            var posts = [Post]()
//            
//            for postSnap in snapshot {
//                guard let postDict = postSnap.value as? [String : Any],
//                    let posterUID = postDict["poster_uid"] as? String
//                    else { continue }
//                
//                dispatchGroup.enter()
//                
//                PostService.fetchPost(withKey: postSnap.key, posterUID: posterUID, completion: { (post) in
//                    if let post = post {
//                        posts.append(post)
//                    }
//                    
//                    dispatchGroup.leave()
//                })
//                
//            }
//            
//            dispatchGroup.notify(queue: .main, execute: {
//                completion(posts.reversed())
//            })
//        })
//    }
//    
//    //----- Chat -----//
//    
//    static func following(for user: User = User.current, completion: @escaping ([User]) -> Void) {
//        // 1
//        let followingRef = Database.database().reference().child("following").child(user.uid)
//        followingRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            // 2
//            guard let followingDict = snapshot.value as? [String : Bool] else {
//                return completion([])
//            }
//            
//            // 3
//            var following = [User]()
//            let dispatchGroup = DispatchGroup()
//            
//            for uid in followingDict.keys {
//                dispatchGroup.enter()
//                
//                show(forUID: uid) { user in
//                    if let user = user {
//                        following.append(user)
//                    }
//                    
//                    dispatchGroup.leave()
//                }
//            }
//            
//            // 4
//            dispatchGroup.notify(queue: .main) {
//                completion(following)
//            }
//        })
//    }
    
}
