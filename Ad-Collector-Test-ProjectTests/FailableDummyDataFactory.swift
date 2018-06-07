//
//  FailDummyDataFactory.swift
//  Ad-Collector-Test-ProjectTests
//
//  Created by Trevin Wisaksana on 07/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import SwiftyJSON

@testable import Ad_Collector_Test_Project

class FailableDummyDataFactory: DummyDataFactoryProtocol {
    
    let discoverJSONPath = Bundle.main.path(forResource: "discover", ofType: "json")
    
    func dummyAdvertisements(completion: @escaping AdvertisementOperationClosure) {
        guard let path = discoverJSONPath else {
            let error = NSError(domain: "Path not found.", code: 0, userInfo: nil)
            completion([Advertisement](), error)
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            guard let discoverJSON = NSData(contentsOfFile: path) else {
                let error = NSError(domain: "Failed to retrieve data from path.", code: 0, userInfo: nil)
                completion([Advertisement](), error)
                return
            }
            
            guard let jsonArray = JSON(discoverJSON)[""].array else {
                let error = NSError(domain: "JSON parsing error.", code: 0, userInfo: nil)
                completion([Advertisement](), error)
                return
            }
            
            let advertisements = jsonArray.compactMap {
                Advertisement(with: $0, isSaved: false)
            }
            
            completion(advertisements, nil)
        }
    }
    
    func dummyLikedAdvertisements(completion: @escaping AdvertisementOperationClosure) {
        guard let path = discoverJSONPath else {
            fatalError()
        }
        
        DispatchQueue.global(qos: .background).async {
            guard let discoverJSON = NSData(contentsOfFile: path) else {
                fatalError()
            }
            
            guard let jsonArray = JSON(discoverJSON)[""].array else {
                return
            }
            
            let advertisements = jsonArray.compactMap {
                Advertisement(with: $0, isSaved: false)
            }
            
            advertisements.forEach { (advertisement) in
                advertisement.isLiked = true
            }
            
            completion(advertisements, nil)
        }
    }
    
}
