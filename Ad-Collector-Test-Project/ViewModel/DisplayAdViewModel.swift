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
    
    func setLikeStatus(for ad: Advertisement) {
        let connection = likeService.newConnection()
        likeService.fetchAd(withKey: ad.key, connection: connection) { (advertisement) in
            if advertisement == nil {
                self.removeLike(for: ad)
            } else {
                self.likeAdvertisement(for: ad)
            }
        }
    }
    
    func removeLike(for ad: Advertisement) {
        let connection = likeService.newConnection()
        likeService.removeLike(for: ad, connection: connection) { (success) in
            print("Sucessfully removed like: \(success)")
        }
    }
    
    func likeAdvertisement(for ad: Advertisement) {
        let connection = likeService.newConnection()
        likeService.like(favoriteAd: ad, connection: connection) { (success) in
            print("Sucessfully liked ad: \(success)")
        }
    }
    
}
