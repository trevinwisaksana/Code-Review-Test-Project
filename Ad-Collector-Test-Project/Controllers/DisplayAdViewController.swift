//
//  DisplayAdViewController.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 23/05/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class DisplayAdViewController: UIViewController {
    
    //---- Properties ----//
    
    let dataSource = DisplayAdViewModel(service: LikeService())
    
    //---- IBOutlet ----//
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //---- VC Lifecycle ----//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //---- IBAction ----//
    
    @IBAction func didPressCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //---- Miscellaneous ----//
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension DisplayAdViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let advertisement = dataSource.content {
            switch indexPath.section {
            case 0:
                let cell: AdImageCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configure(advertisement)
                return cell
            case 1:
                let cell: AdCaptionCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configure(advertisement)
                return cell
            case 2:
                let cell: AdActionCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.likeableDelegate = self
                cell.sharableDelegate = self
                cell.configure(advertisement)
                return cell
            default:
                fatalError("Index Path out of range.")
            }
        } else {
            fatalError("Advertisement is nil.")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: view.frame.width, height: view.frame.height * 0.7)
        case 1:
            return CGSize(width: view.frame.width, height: view.frame.height * 0.2)
        case 2:
            return CGSize(width: view.frame.width, height: view.frame.height * 0.1)
        default:
            fatalError("Index Path out of range")
        }
    }
    
}

extension DisplayAdViewController: Likeable {
    
    func didTapLikeButton(_ likeButton: UIButton, on cell: UICollectionViewCell) {
        guard let adSelected = dataSource.content else {
            return
        }
        
        dataSource.likeService.setLike(status: adSelected.isLiked, for: adSelected) { (success) in
            
        }
    }
    
}

extension DisplayAdViewController: Shareable {
    
    func didTapShareButton() {
        
        guard let advertisement = dataSource.content else {
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: [advertisement], applicationActivities: [])
        
        present(activityVC, animated: true, completion: nil)
    }
    
}

