//
//  LikeService.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

protocol LikeServiceProtocol: class {
     func setLike(status isLiked: Bool, for advertisement: Advertisement, success: @escaping (Bool) -> Void)
    func like(_ advertisement: Advertisement, success: @escaping (Bool) -> Void)
    func unlike(_ advertisement: Advertisement, success: @escaping (Bool) -> Void)
}

class LikeService: LikeServiceProtocol {
    
    var coreDataHelper = CoreDataHelper()
    
    func setLike(status isLiked: Bool, for advertisement: Advertisement, success: @escaping (Bool) -> Void) {
        if isLiked {
            unlike(advertisement, success: success)
        } else {
            like(advertisement, success: success)
        }
    }
    
    func like(_ advertisement: Advertisement, success: @escaping (Bool) -> Void) {
        advertisement.isLiked = true
        
        coreDataHelper.save { (isSuccessful, error) in
            success(isSuccessful)
        }
    }
    
    func unlike(_ advertisement: Advertisement, success: @escaping (Bool) -> Void) {
        advertisement.isLiked = false
        
        coreDataHelper.save { (isSuccessful, error) in
            success(isSuccessful)
        }
    }
    
}
