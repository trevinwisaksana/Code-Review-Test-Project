//
//  CreateUsernameViewController.swift
//  Makestagram
//
//  Created by Trevin Wisaksana on 03/12/2017.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

final class CreateUsernameViewController: UIViewController {
    
    //---- Properties ----//
    
    var userService = UserService()
    
    //-------- IBOutlets --------//
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var usernameContainerStackView: UIStackView!
    
    //-------- VC Lifecycle --------//
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //-------- IBAction --------//
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        createUser()
    }
    
    private func createUser() {
        
        // Checks if the username already exists
        guard let firUser = Auth.auth().currentUser, let username = usernameTextField.text, !username.isEmpty else {
            return
        }
        
        userService.create(firUser, username: username) { (user) in
            
            guard let user = user else {
                return
            }
            
            User.setCurrent(user, writeToUserDefaults: true)
            
            let initialViewController = UIStoryboard.initialViewController(for: .main)
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
        
}
