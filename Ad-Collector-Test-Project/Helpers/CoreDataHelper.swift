//
//  CoreDataHelper.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct CoreDataHelper {
    
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    static func newAdvertisement() -> Advertisement {
        let advertisement = NSEntityDescription.insertNewObject(forEntityName: "FavoriteAd", into: context) as! Advertisement
        return advertisement
    }
    
    static func save(success: @escaping (Bool, Error?) -> Void) {
        DispatchQueue.global().async {
            do {
                try context.save()
                success(true, nil)
            } catch let error {
                success(false, error)
            }
        }
    }
    
    static func delete(_ advertisement: Advertisement, success: @escaping (Bool, Error?) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        DispatchQueue.global().async {
            context.delete(advertisement)
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        save { (sucesss, error) in
            if let error = error {
                success(false, error)
            }
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .global()) {
            success(true, nil)
        }
    }
    
    static func retrieveAdvertisements() -> [Advertisement] {
        do {
            let fetchRequest = NSFetchRequest<Advertisement>(entityName: "FavoriteAd")
            let results = try context.fetch(fetchRequest)
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            return[]
        }
    }
    
    static func fetchAdvertisement(withKey key: String, completion: @escaping (Advertisement?) -> Void) {
        let fetchRequest = NSFetchRequest<Advertisement>(entityName: key)
        _ = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result) in
            if let advertisement = result.finalResult?.first {
                completion(advertisement)
            } else {
                completion(nil)
            }
        }
    }
}
