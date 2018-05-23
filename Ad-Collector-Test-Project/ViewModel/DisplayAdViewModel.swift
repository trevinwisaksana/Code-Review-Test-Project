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
    
    func removeLike(for ad: FavoriteAd) {
        likeService.remove(ad)
    }
    
    func likeAdvertisement(for ad: Advertisement) {
        likeService.saveToFavorite(ad)
    }
    
}
