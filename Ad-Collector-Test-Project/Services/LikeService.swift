//
//  LikeService.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

struct LikeService {
    
    func setLike(status isLiked: Bool, for advertisement: Advertisement, success: @escaping (Bool) -> Void) {
        if isLiked {
            unlike(advertisement, success: success)
        } else {
            like(advertisement, success: success)
        }
    }
    
    // TODO: Create an asynchronous approach
    func like(_ advertisement: Advertisement, success: @escaping (Bool) -> Void) {
        
        guard let key = advertisement.key else {
            return
        }
        
        guard let advertisement = CoreDataHelper.fetchAdvertisement(withKey: key) else {
            success(false)
            return
        }

        advertisement.isLiked = true

        CoreDataHelper.save()
        success(true)
    }
    
    func unlike(_ advertisement: Advertisement, success: @escaping (Bool) -> Void) {
        guard let key = advertisement.key else {
            return
        }
        
        guard let advertisement = CoreDataHelper.fetchAdvertisement(withKey: key) else {
            success(false)
            return
        }
        
        advertisement.isLiked = false
        
        CoreDataHelper.save()
        success(true)
    }
    
}
