//
//  FavoritesViewController.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import CoreData

final class FavoritesViewController: UIViewController {
    
    //---- Properties ----//
    
    let dataSource = FavoriteAdViewModel(service: LikeService())
    
    //---- Subviews ----//
    
    @IBOutlet weak var tableView: UITableView!
    
    private let emptyContentMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "There are currently no favorites."
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    //---- VC Lifecycle ----//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTimeline()
    }
    
    //---- Data Sourece ----//
    
    func configureDataSource() {
        dataSource.delegate = self
    }
    
    //---- Table View ----//
    
    private func configureTableView() {
        tableView.register(FavoriteAdCell.self)
        tableView.delegate = self
    }
    
    @objc
    private func reloadTimeline() {
        dataSource.fetchFavoriteAds()
    }
    
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections = 0
        
        if dataSource.contentIsEmpty {
            let frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height)
            emptyContentMessageLabel.frame = frame
            emptyContentMessageLabel.center = tableView.center
            tableView.backgroundView = emptyContentMessageLabel
            tableView.separatorStyle = .none
        } else {
            tableView.separatorStyle = .singleLine
            numOfSections = 1
            tableView.backgroundView = nil
        }
        
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ad = dataSource.data(atIndex: indexPath.row)
        let cell: FavoriteAdCell = tableView.dequeueReusableCell()
        cell.delegate = self
        cell.configure(ad)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(view.frame.height * 0.25)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.Storyboard.advertisements, bundle: .main)
        let displayAdVC = storyboard.instantiateViewController(withIdentifier: Constants.Identifier.displayCurrentAd) as! DisplayAdViewController
        
        let adSelected = dataSource.data(atIndex: indexPath.row)
   
        displayAdVC.dataSource.content = adSelected
        
        present(displayAdVC, animated: true, completion: nil)
    }
    
}

extension FavoritesViewController: AdvertisementDataSourceDelegate {
    
    func contentChange() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension FavoritesViewController: Dislikeable {
    
    func didTapDislikeButton(_ dislikeButton: UIButton, on cell: FavoriteAdCell) {
        
        defer {
            dislikeButton.isUserInteractionEnabled = true
        }
        
        dislikeButton.isUserInteractionEnabled = false
        
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let adDisliked = dataSource.data(atIndex: indexPath.row)
        
        dataSource.likeService.unlike(adDisliked) { (success) in
            self.reloadTimeline()
        }
    }
    
}
