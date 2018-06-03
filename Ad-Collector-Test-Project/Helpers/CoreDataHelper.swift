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
        let advertisement = NSEntityDescription.insertNewObject(forEntityName: "Advertisement", into: context) as! Advertisement
        return advertisement
    }
    
    static func save() {
        do {
            try context.save()
        } catch let error {
            print("\(error.localizedDescription)")
        }
    }
    
    static func purgeOutdatedData() {
        let purgeDate = Date().addingTimeInterval(-60 * 60 * 24 * 7) // One week
        let request = NSFetchRequest<Advertisement>(entityName: Constants.Entity.advertisement)
        // Only purge outdated data that is not liked
        request.predicate = NSPredicate(format: "isLiked == NO")
        
        do {
            let results = try context.fetch(request)
            
            for object in results {
                
                guard let timestamp = object.timestamp else {
                    return
                }
                
                if timestamp < purgeDate {
                    context.delete(object)
                }
            }
            
        } catch let error {
            print("\(error.localizedDescription)")
        }
    }
    
    static func delete(_ advertisement: Advertisement, success: @escaping (Bool, Error?) -> Void) {
        context.delete(advertisement)
    }
    
    //---- Fetch ----//
    
    static func retrieveAdvertisements() -> [Advertisement] {
        do {
            let fetchRequest = NSFetchRequest<Advertisement>(entityName: Constants.Entity.advertisement)
            let results = try context.fetch(fetchRequest)
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            return[]
        }
    }
    
    static func fetchLikedAdvertisements() -> [Advertisement] {
        do {
            let fetchRequest = NSFetchRequest<Advertisement>(entityName: Constants.Entity.advertisement)
            fetchRequest.predicate = NSPredicate(format: "isLiked == YES")
            
            let results = try context.fetch(fetchRequest)
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            return[]
        }
    }
    
    static func fetchAdvertisement(withKey key: String) -> Advertisement? {
        do {
            let fetchRequest = NSFetchRequest<Advertisement>(entityName: Constants.Entity.advertisement)
            fetchRequest.predicate = NSPredicate(format: "key = %@", key)
            let results = try context.fetch(fetchRequest).first
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            return nil
        }
    }
    
}
