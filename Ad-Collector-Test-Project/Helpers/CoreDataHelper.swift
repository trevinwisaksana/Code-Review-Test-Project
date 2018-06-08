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
import SwiftyJSON

struct CoreDataHelper {
    
    //---- Properties ----//
    
    private static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let persistentContainer: NSPersistentContainer = {
        let container = appDelegate.persistentContainer
        
        return container
    }()
    
    let persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = appDelegate.persistentContainer.persistentStoreCoordinator
        return coordinator
    }()
    
    let managedContext: NSManagedObjectContext = {
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    private let privateContext: NSManagedObjectContext = {
        var privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        privateContext.automaticallyMergesChangesFromParent = true
        privateContext.parent = persistentContainer.viewContext
        
        return privateContext
    }()
    
    var fetchResultsControler: NSFetchedResultsController<Advertisement> = {
        let fetchRequest = NSFetchRequest<Advertisement>(entityName: Constants.Entity.advertisement)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "score", ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }()
    
    //---- Save ----//
    
    func saveJSON(data: [JSON], completion: @escaping AdvertisementOperationClosure) {
        
        if data.isEmpty {
            return
        }
        
        privateContext.perform {
            let advertisements = data.compactMap { Advertisement(with: $0, isSaved: true) }
            completion(advertisements, nil)
        }
    }
    
    func save(success: @escaping SuccessOperationClosure) {
        do {
            try privateContext.save()
            managedContext.performAndWait {
                do {
                    try managedContext.save()
                    success(true, nil)
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    //---- Purge Data ----//
    
    // TODO: Use this
    func purgeOutdatedData(success: @escaping SuccessOperationClosure) {
        let purgeDate = Date().addingTimeInterval(-60 * 60 * 24) // One day
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Entity.advertisement)
        
        // Only purge outdated data that is not liked
        let isLikedPredicate = NSPredicate(format: "isLiked == NO")
        let datePredicate = NSPredicate(format: "timestamp < %@", purgeDate as NSDate)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [isLikedPredicate, datePredicate])
        
        fetchRequest.includesPropertyValues = false
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        privateContext.perform {
            do {
                try self.persistentStoreCoordinator.execute(deleteRequest, with: self.managedContext)
                success(true, nil)
            } catch let error as NSError {
                success(false, error)
            }
        }
       
    }
    
    func purgeData(success: @escaping SuccessOperationClosure) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Entity.advertisement)
        // Only purge data that is not liked
        fetchRequest.predicate = NSPredicate(format: "isLiked == NO")
        fetchRequest.includesPropertyValues = false
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        privateContext.perform {
            do {
                try self.persistentStoreCoordinator.execute(deleteRequest, with: self.managedContext)
                success(true, nil)
            } catch let error as NSError {
                success(false, error)
            }
        }
    }
    
    //---- Fetch ----//
    
    func isDuplicate(advertisement: Advertisement) -> Bool {
        guard let key = advertisement.key else {
            fatalError("Advertisement key does not exist.")
        }
        
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Entity.advertisement)
            fetchRequest.predicate = NSPredicate(format: "key == %@", key)
            
            let results = try managedContext.fetch(fetchRequest)
            
            if results.isEmpty {
                return false
            } else {
                return true
            }
            
        } catch let error {
            fatalError("Could not fetch \(error.localizedDescription)")
        }
    }
    
    func retrieveAdvertisements(completion: @escaping AdvertisementOperationClosure) {
        privateContext.perform {
            do {
                let fetchRequest = NSFetchRequest<Advertisement>(entityName: Constants.Entity.advertisement)
                let results = try self.managedContext.fetch(fetchRequest)
                completion(results, nil)
            } catch let error {
                print("Could not fetch \(error.localizedDescription)")
                completion([Advertisement](), error)
            }
        }
    }
    
    func retrieveLikedAdvertisements(completion: @escaping AdvertisementOperationClosure) {
        privateContext.perform {
            do {
                let fetchRequest = NSFetchRequest<Advertisement>(entityName: Constants.Entity.advertisement)
                fetchRequest.predicate = NSPredicate(format: "isLiked == YES")

                let results = try self.managedContext.fetch(fetchRequest)
                completion(results, nil)
            } catch let error {
                print("Could not fetch \(error.localizedDescription)")
                completion([Advertisement](), error)
            }
        }
    }
    
}
