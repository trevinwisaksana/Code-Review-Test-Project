//
//  AdImageCell.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 23/05/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SDWebImage

final class AdImageCell: UICollectionViewCell {
    
    //---- IBOutlet ----//
    
    @IBOutlet weak var imageView: UIImageView!
    
    //---- Configuration Methods ----//
    
    func configure(_ data: Advertisement) {
        if let posterURL = data.posterURL  {
            configureImage(withURL: posterURL)
        }
    }
    
    private func configureImage(withURL url: String) {
        let imageURL = URL(string: "https://images.finncdn.no/dynamic/480x360c/\(url)")
        
        let placeholderImage = UIImage(named: Constants.Image.placeholderImage)
        imageView.sd_setImage(with: imageURL, placeholderImage: placeholderImage, options: .scaleDownLargeImages, completed: nil)
    }
    
}
