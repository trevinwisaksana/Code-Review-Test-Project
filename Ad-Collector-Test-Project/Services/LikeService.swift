//
//  LikeService.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

class LikeService {
    
    //---- Database Methods ----//
    
    // New Database Connection
    
    func newConnection() -> YapDatabaseConnection {
        let connection = database.newConnection()
        
        return connection
    }
    
    // Like Ad
    
    func like(favoriteAd: Advertisement, connection: YapDatabaseConnection, completion: @escaping (Bool) -> Void) {
        var success = false
        
        connection.readWrite { (transaction) in
            success = self.save(favoriteAd: favoriteAd, transaction: transaction)
            completion(success)
        }
    }
    
    private func save(favoriteAd: Advertisement, transaction: YapDatabaseReadWriteTransaction) -> Bool {
        transaction.setObject(favoriteAd, forKey: favoriteAd.key, inCollection: Constants.Collection.favoriteAd)
        return true
    }
    
    // Retrieve Likes
    
    func retrieveLikedAds(connection: YapDatabaseConnection, completion: @escaping ([Advertisement]) -> Void) {
        var favoriteAds = [Advertisement]()
        
        connection.read { (transaction) in
            favoriteAds = self.retrieve(transaction: transaction)
            completion(favoriteAds)
        }
    }
    
    private func retrieve(transaction: YapDatabaseReadTransaction) -> [Advertisement] {
        var favoriteAds = [Advertisement]()
        
        transaction.enumerateKeysAndObjects(inCollection: Constants.Collection.favoriteAd) { (_, object, _) in
            if let favoriteAd = object as? Advertisement {
                favoriteAds.append(favoriteAd)
            }
        }
        
        return favoriteAds
    }
    
    func fetchAd(withKey key: String, connection: YapDatabaseConnection, completion: @escaping (Advertisement?) -> Void) {
        connection.read { (transaction) in
            let ad = self.fetchAd(key: key, transaction: transaction)
            completion(ad)
        }
    }
    
    private func fetchAd(key: String, transaction: YapDatabaseReadTransaction) -> Advertisement? {
        let favoriteAd = transaction.object(forKey: key, inCollection: Constants.Collection.favoriteAd) as? Advertisement
        return favoriteAd
    }
    
    // Remove Note
    
    func removeLike(for ad: Advertisement, connection: YapDatabaseConnection, completion: @escaping (Bool) -> Void) {
        var success: Bool = false
        
        connection.readWrite { (transaction) in
            success = self.remove(favoriteAd: ad, transaction: transaction)
            completion(success)
        }
    }
    
    private func remove(favoriteAd: Advertisement, transaction: YapDatabaseReadWriteTransaction) -> Bool {
        transaction.removeObject(forKey: favoriteAd.key, inCollection: Constants.Collection.favoriteAd)
        return true
    }
    
}
