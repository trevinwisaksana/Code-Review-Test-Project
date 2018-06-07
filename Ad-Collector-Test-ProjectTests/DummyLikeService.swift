//
//  DummyLikeService.swift
//  Ad-Collector-Test-ProjectTests
//
//  Created by Trevin Wisaksana on 20/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

@testable import Ad_Collector_Test_Project

class DummyLikeService: LikeServiceProtocol {
    
    func setLike(status isLiked: Bool, for advertisement: Advertisement, success: @escaping (Bool) -> Void) {
        if isLiked {
            unlike(advertisement, success: success)
        } else {
            like(advertisement, success: success)
        }
    }
    
    func like(_ advertisement: Advertisement, success: @escaping (Bool) -> Void) {
        advertisement.isLiked = true
    }
    
    func unlike(_ advertisement: Advertisement, success: @escaping (Bool) -> Void) {
        advertisement.isLiked = false
    }
    
}
