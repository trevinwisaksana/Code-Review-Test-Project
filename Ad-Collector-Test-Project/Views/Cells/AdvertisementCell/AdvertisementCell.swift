//
//  AdvertisementCell.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SDWebImage

protocol Likeable: class {
    func didTapLikeButton(_ likeButton: UIButton, on cell: UICollectionViewCell)
}


final class AdvertisementCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    weak var delegate: Likeable?
    private var adKey: String?
    
    func configure(_ data: Advertisement) {
        likeButton.isSelected = data.isLiked
        adKey = data.key
        titleLabel.text = data.title
        locationLabel.text = data.location
        priceLabel.text = "kr " + Int(data.price).decimalStyleString
        
        if let posterURL = data.posterURL {
            configureImage(withURL: posterURL)
        }
    }
    
    private func configureImage(withURL url: String) {
        let imageURL = URL(string: "https://images.finncdn.no/dynamic/480x360c/\(url)")
        
        let placeholderImage = UIImage(named: Constants.Image.placeholderImage)
        photoImageView.sd_setImage(with: imageURL, placeholderImage: placeholderImage, options: .scaleDownLargeImages, completed: nil)
        
        photoImageView.layer.cornerRadius = 5
    }
    
    @IBAction func didTapLikeButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.didTapLikeButton(sender, on: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthConstraint.constant = screenWidth
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        likeButton.isSelected = false
    }
    
}
