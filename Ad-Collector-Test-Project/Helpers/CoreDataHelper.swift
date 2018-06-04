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
    
    static let persistentContainer: NSPersistentContainer = {
        let container = appDelegate.persistentContainer
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    static let context: NSManagedObjectContext = {
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    private static let backgroundContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        
        return context
    }()
    
    static func save(success: @escaping SuccessOperationClosure) {
        appDelegate.saveContext()
    }
    
    static func purgeOutdatedData(success: @escaping SuccessOperationClosure) {
        let purgeDate = Date().addingTimeInterval(-60 * 60 * 24) // One day
        let request = NSFetchRequest<Advertisement>(entityName: Constants.Entity.advertisement)
        
        // Only purge outdated data that is not liked
        request.predicate = NSPredicate(format: "isLiked == NO")
        
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
        backgroundContext.perform {
            do {
                let fetchRequest = NSFetchRequest<Advertisement>(entityName: Constants.Entity.advertisement)
                let results = try backgroundContext.fetch(fetchRequest)
                completion(results, nil)
            } catch let error {
                print("Could not fetch \(error.localizedDescription)")
                completion([Advertisement](), error)
            }
        }
    }
    
    static func fetchLikedAdvertisements(completion: @escaping AdvertisementOperationClosure) {
        backgroundContext.perform {
            do {
                let fetchRequest = NSFetchRequest<Advertisement>(entityName: Constants.Entity.advertisement)
                fetchRequest.predicate = NSPredicate(format: "isLiked == YES")
                
                let results = try backgroundContext.fetch(fetchRequest)
                completion(results, nil)
            } catch let error {
                print("Could not fetch \(error.localizedDescription)")
                completion([Advertisement](), error)
            }
        }
        
    }
    
}
