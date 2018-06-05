//
//  Advertisement.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

extension Advertisement {
    
    convenience init?(with json: JSON, isSaved: Bool) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Advertisement", in: CoreDataHelper.context) else {
            fatalError("Entity does not exist.")
        }
        
        if isSaved {
            self.init(entity: entity, insertInto: CoreDataHelper.context)
        } else {
            self.init(entity: entity, insertInto: nil)
        }
        
        guard let title = json["description"].string else {
            return nil
        }

        guard let location = json["location"].string else {
            return nil
        }

        guard let adType = json["ad-type"].string else {
            return nil
        }

        guard let rawScoreResponseString = json["score"].string else {
            return nil
        }

        guard let score = Double(rawScoreResponseString) else {
            return nil
        }
        
        let key = json["id"].stringValue
        let posterURL = json["image"]["url"].string ?? ""
        let price = json["price"]["value"].doubleValue

        self.title = title
        self.price = price
        self.location = location
        self.posterURL = posterURL
        self.key = key
        self.type = adType
        self.score = score
        self.timestamp = Date()
    }
    
}

extension Advertisement: UIActivityItemSource {
    
    public func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        let placeholder = "Share this advertisement"
        return placeholder
    }
    
    public func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType?) -> Any? {
        
        let price = self.price
        let title = self.title
        let location = self.location
        
        let message =
        """
        Hi! Check this item in \(location!)!
        
        \(title!).
        
        The price is kr \(Int(price).decimalStyleString).
        """
        
        switch activityType {
        case UIActivityType.mail:
            return message
        case UIActivityType.message:
            return message
        default:
            return message
        }
    }
    
}
