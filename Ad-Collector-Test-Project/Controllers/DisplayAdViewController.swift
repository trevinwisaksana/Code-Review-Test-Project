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
        // Do any additional setup after loading the view, typically from a nib.
        
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
        
        if let selectedAd = dataSource.content {
            
            switch indexPath.section {
            case 0:
                let cell: AdImageCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configure(selectedAd)
                return cell
            case 1:
                let cell: AdCaptionCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configure(selectedAd)
                return cell
            case 2:
                let cell: AdActionCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configure(selectedAd)
                return cell
            default:
                fatalError("Index Path out of range.")
            }
            
        } else {
            fatalError("Cannot find selected ad.")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: view.frame.width, height: view.frame.height * 0.7)
        case 1:
            return CGSize(width: view.frame.width, height: view.frame.height * 0.18)
        case 2:
            return CGSize(width: view.frame.width, height: view.frame.height * 0.15)
        default:
            fatalError("Index Path out of range")
        }
    }
    
}
