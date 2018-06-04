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
    
    private static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let context: NSManagedObjectContext = {
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    static let persistentContainer: NSPersistentContainer = {
        let container = appDelegate.persistentContainer
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    static func save(success: @escaping SuccessOperationClosure) {
        if context.hasChanges {
            do {
                try context.save()
                success(true, nil)
            } catch let error {
                print("\(error.localizedDescription)")
                success(false, error)
            }
        }
    }
    
    static func purgeOutdatedData(success: @escaping SuccessOperationClosure) {
        let purgeDate = Date().addingTimeInterval(-60 * 60 * 24) // One day
        let request = NSFetchRequest<Advertisement>(entityName: Constants.Entity.advertisement)
        
        // Only purge outdated data that is not liked
        request.predicate = NSPredicate(format: "isLiked == NO")
        
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.perform {
            do {
                let results = try backgroundContext.fetch(request)
                
                if results.isEmpty {
                    success(true, nil)
                    return
                }
                
                for object in results {
                    guard let timestamp = object.timestamp else {
                        return
                    }
                    
                    if timestamp < purgeDate {
                        backgroundContext.delete(object)
                    }
                }
                
                success(true, nil)
            } catch let error {
                print("\(error.localizedDescription)")
                success(false, error)
            }
        }
       
    }
    
    //---- Fetch ----//
    
    static func retrieveAdvertisements(completion: @escaping AdvertisementOperationClosure) {
        context.perform {
            do {
                let fetchRequest = NSFetchRequest<Advertisement>(entityName: Constants.Entity.advertisement)
                let results = try context.fetch(fetchRequest)
                completion(results, nil)
            } catch let error {
                print("Could not fetch \(error.localizedDescription)")
                completion([Advertisement](), error)
            }
        }
    }
    
    static func fetchLikedAdvertisements(completion: @escaping AdvertisementOperationClosure) {
        context.perform {
            do {
                let fetchRequest = NSFetchRequest<Advertisement>(entityName: Constants.Entity.advertisement)
                fetchRequest.predicate = NSPredicate(format: "isLiked == YES")
                
                let results = try context.fetch(fetchRequest)
                completion(results, nil)
            } catch let error {
                print("Could not fetch \(error.localizedDescription)")
                completion([Advertisement](), error)
            }
        }
    }
    
//    static func fetchAdvertisement(withKey key: String, completion: @escaping FetchAdvertisementOperationClosure) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//
//        backgroundContext.perform {
//            do {
//                let fetchRequest = NSFetchRequest<Advertisement>(entityName: Constants.Entity.advertisement)
//                fetchRequest.predicate = NSPredicate(format: "key = %@", key)
//
//                guard let result = try context.fetch(fetchRequest).first else {
//                    return
//                }
//
//                completion(result, nil)
//            } catch let error {
//                print("Could not fetch \(error.localizedDescription)")
//                completion(nil, error)
//            }
//        }
//    }
    
}
