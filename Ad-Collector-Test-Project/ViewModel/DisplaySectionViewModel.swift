//
//  DisplaySectionViewModel.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 18/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

final class DisplaySectionViewModel {
    
    //---- Properties ----//
    
    weak var delegate: AdvertisementDataSourceDelegate?
    
    var likeService: LikeService
    
    //---- Initializer ----//
    
    init(service: LikeService) {
        self.likeService = service
    }
    
    //---- Data Source ----//
    
    fileprivate var content = [Advertisement]() {
        didSet {
            delegate?.contentChange()
        }
    }
    
    var numberOfItems: Int {
        return content.count
    }
    
    func data(atIndex index: Int) -> Advertisement {
        return content[index]
    }
    
    func loadContent(_ data: [Advertisement]) {
        content = data
    }
    
    func determineSectionTitle() -> String {
        let advertisement = content[0]
        
        switch advertisement.type {
        case Constants.AdType.bap:
            return "Books"
        case Constants.AdType.realEstate:
            return "Real Estate"
        case Constants.AdType.car:
            return "Cars"
        default:
            fatalError("Error: unexpected type.")
        }
    }
    
    //---- Like Service ----//
    
    func setLikeStatus(for ad: Advertisement) {
        let connection = likeService.newConnection()
        likeService.fetchAd(withKey: ad.key, connection: connection) { (advertisement) in
            if advertisement == nil  {
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
