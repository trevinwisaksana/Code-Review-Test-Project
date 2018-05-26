//
//  Advertisement.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import SwiftyJSON

final class Advertisement: NSObject, NSCoding {
    
    var title: String
    var price: Int
    var photoURL: String?
    var location: String
    var key: String
    var type: String
    var score: Double

    var isFavorite = false

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
        let photoURL = json["image"]["url"].string ?? ""

        self.title = title
        self.price = price
        self.location = location
        self.photoURL = photoURL
        self.key = key
        self.type = adType
        self.score = score
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(photoURL, forKey: "photoURL")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(key, forKey: "key")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(score, forKey: "score")
        aCoder.encode(isFavorite, forKey: "isFavorite")
    }
    
    init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as! String
        price = aDecoder.decodeInteger(forKey: "price")
        photoURL = aDecoder.decodeObject(forKey: "photoURL") as? String
        location = aDecoder.decodeObject(forKey: "location") as! String
        key = aDecoder.decodeObject(forKey: "key") as! String
        type = aDecoder.decodeObject(forKey: "type") as! String
        score = aDecoder.decodeDouble(forKey: "score")
        isFavorite = aDecoder.decodeBool(forKey: "isFavorite")
    }

}
