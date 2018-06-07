//
//  AdvertisementService.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol AdvertisementServiceProtocol: class {
    func fetchAdvertisements(completion: @escaping AdvertisementOperationClosure)
    func retrieveCachedAds(completion: @escaping AdvertisementOperationClosure)
    func retrieveFavoriteAdvertisements(completion: @escaping AdvertisementOperationClosure)
}

class AdvertisementService: AdvertisementServiceProtocol {
    
    private let baseURL = URL(string: "https://gist.githubusercontent.com/3lvis/3799feea005ed49942dcb56386ecec2b/raw/63249144485884d279d55f4f3907e37098f55c74/discover.json")
    
    var coreDataHelper = CoreDataHelper()
    
    func fetchAdvertisements(completion: @escaping ([Advertisement], Error?) -> Void) {
        
        guard let url = baseURL else {
            return
        }
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 60
        
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result {
            case .success(let data):
                guard let jsonArray = JSON(data)["items"].array else {
                    completion([Advertisement](), nil)
                    return
                }
                
                let advertisements = jsonArray.compactMap { Advertisement(with: $0, isSaved: true) }
                
                CoreDataHelper.save { (success, error) in
                    if let error = error {
                        completion([Advertisement](), error)
                        print("\(error.localizedDescription)")
                        return
                    }
                    
                    completion(advertisements, nil)
                }
 
            case .failure(let error):
                completion([Advertisement](), error)
            }
        }
    }
    
    // Checks if the response has already by cached
    func retrieveCachedAds(completion: @escaping AdvertisementOperationClosure) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        CoreDataHelper.retrieveAdvertisements { (advertisements, error) in
            if advertisements.isEmpty {
                dispatchGroup.leave()
            } else {
                completion(advertisements, error)
            }
        }
        
        dispatchGroup.notify(queue: .global()) {
            self.fetchAdvertisements { (advertisement, error) in
                if let error = error {
                    completion([Advertisement](), error)
                    return
                }
                
                completion(advertisement, nil)
            }
        }
        
    }
    
    func retrieveFavoriteAdvertisements(completion: @escaping AdvertisementOperationClosure) {
        CoreDataHelper.fetchLikedAdvertisements { (advertisements, error) in
            if let error = error {
                completion([Advertisement](), error)
            } else {
                completion(advertisements, nil)
            }
        }
    }
    
}
