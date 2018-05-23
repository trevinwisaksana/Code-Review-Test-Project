//
//  AdCaptionCell.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 23/05/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class AdCaptionCell: UICollectionViewCell {
    
    //---- IBOutlets ----//
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    //---- Configuration Methods ----//
    
    func configure(_ data: Advertisement) {
        descriptionLabel.text = data.title
        locationLabel.text = data.location
        priceLabel.text = "kr " + Int(data.price).decimalStyleString
    }
    
}
