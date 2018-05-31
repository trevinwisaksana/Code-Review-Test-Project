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
            return nil
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
