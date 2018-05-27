//
//  DisplayAdViewModel.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 23/05/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

final class DisplayAdViewModel {
    
    //---- Properties ----//
    
    weak var delegate: AdvertisementDataSourceDelegate?
    
    var likeService: LikeService
    
    //---- Initializer ----//
    
    init(service: LikeService) {
        self.likeService = service
    }
    
    //---- Data Source ----//
    
    var content: Advertisement? {
        didSet {
            delegate?.contentChange()
        }
    }
    
    func load(_ ad: Advertisement) {
        content = ad
    }
    
    //---- Like Service ----//
    
    func adIsLiked(status: Bool, for ad: Advertisement, success: @escaping (Bool) -> Void) {
        likeService.setIsLiked(status, for: ad) { (isSuccessful) in
            success(isSuccessful)
        }
    }
}
