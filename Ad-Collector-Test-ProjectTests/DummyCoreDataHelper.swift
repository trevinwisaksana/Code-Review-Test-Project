//
//  DummyCoreDataHelper.swift
//  Ad-Collector-Test-ProjectTests
//
//  Created by Trevin Wisaksana on 06/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

@testable import Ad_Collector_Test_Project

class DummyCoreDataHelper: CoreDataHelper {
    
    var dummyDataFactory: DummyDataFactoryProtocol
    
    init(dummyDataFactory: DummyDataFactoryProtocol) {
        self.dummyDataFactory = dummyDataFactory
    }
    
    func save(success: @escaping SuccessOperationClosure) {
        
    }
    
    func purgeOutdatedData(success: @escaping SuccessOperationClosure) {
        
    }
    
    //---- Fetch ----//
    
    func retrieveAdvertisements(completion: @escaping AdvertisementOperationClosure) {
        dummyDataFactory.dummyAdvertisements(completion: completion)
    }
    
    func retrieveLikedAdvertisements(completion: @escaping AdvertisementOperationClosure) {
        dummyDataFactory.dummyLikedAdvertisements(completion: completion)
    }
    
}
