//
//  PostService.swift
//  Makestagram
//
//  Created by Trevin Wisaksana on 06/12/2017.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

struct PostAdService {

    var storageService = StorageService()
    var userService = UserService()
    
    private static let databaseReference = Database.database().reference()
    private static let currentUser = User.current
    private static let currentUID = currentUser.uid

    func create(for image: UIImage) {
        let imageRef = storageService.newPostImageReference()
        storageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }

            let urlString = downloadURL.absoluteString
            let aspectHeight = image.aspectHeight
            create(forURLString: urlString, aspectHeight: aspectHeight)
        }
    }

    func fetchPost(withKey key: String, posterUID: String, completion: @escaping (Post?) -> Void) {
        let postReference = DatabaseReference.toLocation(.fetchPost(uid: posterUID, postKey: key))

        postReference.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let post = Post(snapshot: snapshot) else {
                return completion(nil)
            }

            LikeService.isPostLiked(post) { (isLiked) in
                post.isLiked = isLiked
                completion(post)
            }
        })

    }

    private func create(forURLString urlString: String, aspectHeight: CGFloat) {

        let post = Post(imageURL: urlString, imageHeight: aspectHeight)

        // We create references to the important locations that we're planning to write data.

        let newPostRef = DatabaseReference.toLocation(.newPost(currentUID: currentUID))
        let newPostKey = newPostRef.key

        // Use our class method to get an array of all of our follower UIDs
        userService.followers(for: currentUser) { (followerUIDs) in

            // We construct a timeline JSON object where we store our current user's uid. We need to do this because when we fetch a timeline for a given user, we'll need the uid of the post in order to read the post from the Post subtree.
            let timelinePostDict = ["poster_uid" : currentUser.uid]

            // We create a mutable dictionary that will store all of the data we want to write to our database. We initialize it by writing the current timeline dictionary to our own timeline because our own uid will be excluded from our follower UIDs.
            var updatedData: [String : Any] = ["timeline/\(currentUser.uid)/\(newPostKey)" : timelinePostDict]

            // We add our post to each of our follower's timelines.
            for uid in followerUIDs {
                updatedData["timeline/\(uid)/\(newPostKey)"] = timelinePostDict
            }

            // We make sure to write the post we are trying to create.
            let postDict = post.dictValue
            updatedData["posts/\(currentUser.uid)/\(newPostKey)"] = postDict

            // We write our multi-location update to our database.
            databaseReference.updateChildValues(updatedData)
        }

    }

}
