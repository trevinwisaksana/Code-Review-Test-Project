//
//  DisplaySectionViewController.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 18/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import Reachability

final class DisplaySectionViewController: UIViewController {
    
    //---- Properties ----//
    
    let dataSource = DisplaySectionViewModel()
    
    private lazy var alertController = UIAlertController()
    
    //---- Subviews ----//
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //---- Initializer ----//
    
    func load(content: [Advertisement]) {
        dataSource.loadContent(content)
    }
    
    //---- VC Lifecycle ----//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
    }
    
    //---- IBAction ----//
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //---- Data Source ----//
    
    private func configureDataSource() {
        dataSource.delegate = self
    }
    
    //---- Collection View ----//
    
    private func configureCollectionView() {
        collectionView.register(AdvertisementCell.self)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let height = view.frame.height * 0.8
            flowLayout.estimatedItemSize = CGSize(width: 50, height: height)
            flowLayout.minimumLineSpacing = 2
        }
    }
    
    //---- Miscellaneous ----//
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension DisplaySectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let sectionAd = dataSource.data(atIndex: indexPath.row)
        
        let cell: AdvertisementCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
        cell.configure(sectionAd)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let sectionHeader: DisplaySectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            
            sectionHeader.titleLabel.text = dataSource.determineSectionTitle()
            
            return sectionHeader
            
        default:
            fatalError("Error: unexpected indexPath.")
        }
    }
    
}

extension DisplaySectionViewController: AdvertisementDataSourceDelegate {
    
    func refresh() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}

extension DisplaySectionViewController: Likeable {
    
    func didTapLikeButton(_ likeButton: UIButton, on cell: UICollectionViewCell) {
        
        defer {
            likeButton.isUserInteractionEnabled = true
        }
        
        likeButton.isUserInteractionEnabled = false
        
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        
        let adSelected = dataSource.data(atIndex: indexPath.row)
        
        dataSource.likeService.setLike(status: adSelected.isLiked, for: adSelected) { (success) in
            
        }
    }
    
}

extension DisplaySectionViewController: NetworkStatusListener {
    
    func networkStatusDidChange(status: Reachability.Connection) {
        switch status {
        case .none:
            displayErrorMessage()
        case .cellular, .wifi:
            break
        }
    }
    
    private func displayErrorMessage() {
        alertController.title = "Network Error"
        alertController.message = "You are not connected to the internet."
        
        present(alertController, animated: true) {
            self.addAlertControllerTapGesture()
        }
    }
    
    private func addAlertControllerTapGesture() {
        let selector = #selector(alertControllerTapGestureHandler)
        let tapGesture = UITapGestureRecognizer(target: self, action: selector)
        let alertControllerSubview = alertController.view.superview?.subviews[1]
        alertControllerSubview?.isUserInteractionEnabled = true
        alertControllerSubview?.addGestureRecognizer(tapGesture)
    }
    
    @objc private func alertControllerTapGestureHandler() {
        dismiss(animated: true, completion: nil)
    }
    
}

