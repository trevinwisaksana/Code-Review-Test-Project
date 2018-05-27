//
//  Advertisement.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import SwiftyJSON
import Firebase

final class Advertisement: NSObject, NSCoding {
    
    var title: String
    var price: Int
    var posterURL: String?
    var location: String
    var key: String // Check if this has to be an optional
    var type: String
    var score: Double
    
    var isLiked = false
    
    init?(snapshot: DataSnapshot) {
        
        guard let data = snapshot.value as? JSON else {
            return nil
        }
        
        guard let title = data["description"].string else {
            return nil
        }
        
        guard let price = data["price"]["value"].int else {
            return nil
        }
        
        guard let location = data["location"].string else {
            return nil
        }
        
        guard let adType = data["ad-type"].string else {
            return nil
        }
        
        guard let rawScoreResponseString = data["score"].string else {
            return nil
        }
        
        guard let score = Double(rawScoreResponseString) else {
            return nil
        }
        
        let posterURL = data["image"]["url"].string ?? ""
        
        self.title = title
        self.price = price
        self.location = location
        self.posterURL = posterURL
        self.key = snapshot.key
        self.type = adType
        self.score = score
    }
    
    init?(with json: JSON) {
        guard let title = json["description"].string else {
            return nil
        }
        
        guard let price = json["price"]["value"].int else {
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
        
        self.title = title
        self.price = price
        self.location = location
        self.posterURL = posterURL
        self.key = key
        self.type = adType
        self.score = score
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(posterURL, forKey: "posterURL")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(key, forKey: "key")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(score, forKey: "score")
        aCoder.encode(isLiked, forKey: "isLiked")
    }
    
    init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as! String
        price = aDecoder.decodeInteger(forKey: "price")
        posterURL = aDecoder.decodeObject(forKey: "posterURL") as? String
        location = aDecoder.decodeObject(forKey: "location") as! String
        key = aDecoder.decodeObject(forKey: "key") as! String
        type = aDecoder.decodeObject(forKey: "type") as! String
        score = aDecoder.decodeDouble(forKey: "score")
        isLiked = aDecoder.decodeBool(forKey: "isLiked")
    }
    
}
