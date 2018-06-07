//
//  DummyAdvertisementService.swift
//  Ad-Collector-Test-ProjectTests
//
//  Created by Trevin Wisaksana on 20/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

@testable import Ad_Collector_Test_Project

class DummyAdvertisementService: AdvertisementServiceProtocol {
    
    let dummyCoreDataHelper: DummyCoreDataHelper
    
    init(coreDataHelper: DummyCoreDataHelper) {
        self.dummyCoreDataHelper = coreDataHelper
    }
    
    var data = [Advertisement]()

    func retrieveCachedAds(completion: @escaping ([Advertisement], Error?) -> Void) {
        dummyCoreDataHelper.retrieveAdvertisements { (advertisement, error) in
            completion(advertisement, error)
        }
    }
    
    func fetchAdvertisements(completion: @escaping ([Advertisement], Error?) -> Void) {
        dummyCoreDataHelper.retrieveAdvertisements { (advertisement, error) in
            completion(advertisement, error)
        }
    }
    
    func retrieveFavoriteAdvertisements(completion: @escaping AdvertisementOperationClosure) {
        dummyCoreDataHelper.retrieveAdvertisements { (advertisement, error) in
            completion(advertisement, error)
        }
    }
    
}
