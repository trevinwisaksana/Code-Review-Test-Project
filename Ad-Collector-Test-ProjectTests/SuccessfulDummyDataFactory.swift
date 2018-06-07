//
//  DummyDataFactory.swift
//  Ad-Collector-Test-ProjectTests
//
//  Created by Trevin Wisaksana on 20/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import SwiftyJSON

@testable import Ad_Collector_Test_Project

protocol DummyDataFactoryProtocol {
    func dummyAdvertisements(completion: @escaping AdvertisementOperationClosure)
    func dummyLikedAdvertisements(completion: @escaping AdvertisementOperationClosure)
}

class SuccessfulDummyDataFactory: DummyDataFactoryProtocol {
    
    let discoverJSONPath = Bundle.main.path(forResource: "discover", ofType: "json")
    
    func dummyAdvertisements(completion: @escaping AdvertisementOperationClosure) {
        guard let path = discoverJSONPath else {
            fatalError()
        }
        
        DispatchQueue.global(qos: .background).async {
            guard let discoverJSON = NSData(contentsOfFile: path) else {
                fatalError()
            }
            
            guard let jsonArray = JSON(discoverJSON)["items"].array else {
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
            
            guard let jsonArray = JSON(discoverJSON)["items"].array else {
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
