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
    
//    static func delete(_ advertisement: Advertisement, success: @escaping (Bool, Error?) -> Void) {
//        let dispatchGroup = DispatchGroup()
//
//        dispatchGroup.enter()
//        DispatchQueue.global().async {
//            context.delete(advertisement)
//            dispatchGroup.leave()
//        }
//
//        dispatchGroup.enter()
//        save { (sucesss, error) in
//            if let error = error {
//                success(false, error)
//            }
//
//            dispatchGroup.leave()
//        }
//
//        dispatchGroup.notify(queue: .global()) {
//            success(true, nil)
//        }
//    }
    
    static func unlike(_ advertisement: Advertisement, success: @escaping (Bool) -> Void) {
        guard let key = advertisement.key else {
            return
        }
        
        guard let advertisement = fetchAdvertisement(withKey: key) else {
            success(false)
            return
        }
        
        advertisement.isLiked = false
        
        CoreDataHelper.save { (isSuccessful, error) in
            success(isSuccessful)
            print("WARNING: \(error?.localizedDescription)")
        }
    }
    
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
    
//    static func fetchAdvertisement(withKey key: String, completion: @escaping (Advertisement?) -> Void) {
//        do {
//            let fetchRequest = NSFetchRequest<Advertisement>(entityName: "Advertisement")
//            fetchRequest.predicate = NSPredicate(format: "advertisement.key = %@", key)
//            let results = try context.fetch(fetchRequest).first
//            return results
//        } catch let error {
//            print("Could not fetch \(error.localizedDescription)")
//            return nil
//        }
//    }
}
