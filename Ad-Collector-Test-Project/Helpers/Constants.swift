//
//  Constants.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 18/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

struct Constants {
    
    struct UserDefaults {
        static let currentUser = "currentUser"
        static let uid = "uid"
        static let username = "username"
    }
    
    struct Storyboard {
        static let advertisements = "Advertisements"
    }
    
    struct Identifier {
        static let displaySectionVC = "DisplaySectionViewController"
        static let displayCurrentAd = "DisplayAdViewController"
    }
    
    struct AdType {
        static let car = "CAR"
        static let realEstate = "REALESTATE"
        static let bap = "BAP"
    }
    
    struct Image {
        static let placeholderImage = "placeholderImage"
    }
    
    struct Database {
        private static let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        private static let baseDir = paths.count > 0 ? paths[0] as String : NSTemporaryDirectory() as String
        
        static let path = baseDir + "YapDatabase.sqlite"
    }
    
    struct Collection {
        static let favoriteAd = "FavoriteAd"
        
    }
    
}
