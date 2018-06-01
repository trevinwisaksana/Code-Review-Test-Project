//
//  AdActionCell.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 23/05/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

protocol Shareable: class {
    func didTapShareButton()
}

final class AdActionCell: UICollectionViewCell {
    
    //---- Properties ----//
    
    weak var likeableDelegate: Likeable?
    weak var sharableDelegate: Shareable?
    
    //---- IBOutlets ----//
    
    @IBOutlet weak var likeButton: UIButton!
    
    //---- IBActions ----//
    
    @IBAction func didPressLikeButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        likeableDelegate?.didTapLikeButton(sender, on: self)
    }
    
    @IBAction func didPressShareButton(_ sender: UIButton) {
        sharableDelegate?.didTapShareButton()
    }
    
    @IBAction func didPressChatButton(_ sender: UIButton) {
        
    }
    
    //---- Configuration Methods ----//
    
    func configure(_ data: Advertisement) {
        likeButton.isSelected = data.isLiked
    }
    
}
