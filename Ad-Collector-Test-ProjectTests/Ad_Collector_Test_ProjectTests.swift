//
//  Ad_Collector_Test_ProjectTests.swift
//  Ad-Collector-Test-ProjectTests
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import XCTest
@testable import Ad_Collector_Test_Project

class Ad_Collector_Test_ProjectTests: XCTestCase {
    
    // MARK: - View Model
    var advertisementViewModel: AdvertisementViewModel!
    var displaySectionViewModel: DisplayAdViewModel!
    var favoriteAdViewModel: FavoriteAdViewModel!
    var displayAdViewModel: DisplayAdViewModel!

    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    //---- Advertisement View Model ----//
    
    func test_successful_fetch_advertisement_success() {
        let coreDataHelper = DummyCoreDataHelper(dummyDataFactory: SuccessfulDummyDataFactory())
        let failableAdvertisementService = DummyAdvertisementService(coreDataHelper: coreDataHelper)
        
        advertisementViewModel = AdvertisementViewModel(likeService: DummyLikeService(), adService: failableAdvertisementService)
        
        let expectation = XCTestExpectation(description: "Load advertisements.")
        
        advertisementViewModel.loadAdvertisements { (error) in
            XCTAssertFalse(self.advertisementViewModel.contentIsEmpty)
            XCTAssertEqual(self.advertisementViewModel.numberOfItems, 1000)
            XCTAssertNil(error)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_fetch_cached_advertisement_success() {
        let coreDataHelper = DummyCoreDataHelper(dummyDataFactory: SuccessfulDummyDataFactory())
        let failableAdvertisementService = DummyAdvertisementService(coreDataHelper: coreDataHelper)
        
        advertisementViewModel = AdvertisementViewModel(likeService: DummyLikeService(), adService: failableAdvertisementService)
        
        let expectation = XCTestExpectation(description: "Load cached advertisements.")
        
        advertisementViewModel.loadCachedAdvertisements { (error) in
            XCTAssertFalse(self.advertisementViewModel.contentIsEmpty)
            XCTAssertEqual(self.advertisementViewModel.numberOfItems, 1000)
            XCTAssertNil(error)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_successful_fetch_advertisement_fail() {
        let coreDataHelper = DummyCoreDataHelper(dummyDataFactory: FailableDummyDataFactory())
        let failableAdvertisementService = DummyAdvertisementService(coreDataHelper: coreDataHelper)
        
        advertisementViewModel = AdvertisementViewModel(likeService: DummyLikeService(), adService: failableAdvertisementService)
        
        let expectation = XCTestExpectation(description: "Failed to load advertisements.")
        
        advertisementViewModel.loadAdvertisements { (error) in
            XCTAssertTrue(self.advertisementViewModel.contentIsEmpty)
            XCTAssertEqual(self.advertisementViewModel.numberOfItems, 0)
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_fetch_cached_advertisement_fail() {
        let coreDataHelper = DummyCoreDataHelper(dummyDataFactory: FailableDummyDataFactory())
        let failableAdvertisementService = DummyAdvertisementService(coreDataHelper: coreDataHelper)
        
        advertisementViewModel = AdvertisementViewModel(likeService: DummyLikeService(), adService: failableAdvertisementService)
        
        let expectation = XCTestExpectation(description: "Failed to load advertisements.")
        
        advertisementViewModel.loadCachedAdvertisements { (error) in
            XCTAssertTrue(self.advertisementViewModel.contentIsEmpty)
            XCTAssertEqual(self.advertisementViewModel.numberOfItems, 0)
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    //---- Display Section View Model ----//
    
    func testRandom() {
        
    }
    
}
