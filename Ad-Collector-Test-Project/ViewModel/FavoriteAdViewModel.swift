//
//  FavoriteAdViewModel.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import CoreData

final class FavoriteAdViewModel {
    
    //---- Properties ----//
    
    weak var delegate: AdvertisementDataSourceDelegate?
    
    var likeService: LikeService
    
    //---- Initializer ----//
    
    init(service: LikeService) {
        self.likeService = service
    }
    
    //---- Data Source ----//
    
    private var content = [Advertisement]() {
        didSet {
            delegate?.contentChange()
        }
    }
    
    var numberOfItems: Int {
        return content.count
    }
    
    var contentIsEmpty: Bool {
        return content.isEmpty
    }
    
    func data(atIndex index: Int) -> Advertisement {
        return content[index]
    }
    
    func fetchFavoriteAds() {
        
    }
    
    //---- Like Service ----//
    
    func adIsLiked(status: Bool, for ad: Advertisement, success: @escaping (Bool) -> Void) {
        likeService.setIsLiked(status, for: ad) { (isSuccessful) in
            success(isSuccessful)
        }
    }
    
}
