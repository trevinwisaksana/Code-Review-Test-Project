//
//  SignInViewController.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 23/05/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

final class SignInViewController: UIViewController {
    
    //---- Properties ----//
    
    var userService = UserService()
    
    //----- VC Lifecycle ----//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userService.manipulateDatabase()
    }
    
    //---- IBAction ----//
    
    @IBAction func didPressLoginButton(_ sender: UIButton) {
        presentAuthViewController()
    }

    
    //---- Transition ----//
    
    private func presentAuthViewController() {
        
        guard let authUI = FUIAuth.defaultAuthUI() else { return }
        
        authUI.delegate = self
        
        // add google provider
        let providers: [FUIAuthProvider] = []
        authUI.providers = providers
        
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
    
}

extension SignInViewController: FUIAuthDelegate {
    
    //-------- Authentication --------//
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        
        if let error = error {
            print("Error signing in: \(error.localizedDescription)")
            return
        }
        
        guard let user = user else {
            return
        }
        
        userService.show(forUID: user.uid) { (user) in
            if let user = user {
                // handle existing user
                User.setCurrent(user, writeToUserDefaults: true)
                
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            } else {
                // handle new user
                let storyboard = UIStoryboard(name: "Login", bundle: .main)
                let createUsernameVC = storyboard.instantiateViewController(withIdentifier: "CreateUsernameVC") as! CreateUsernameViewController
                self.present(createUsernameVC, animated: true, completion: nil)
            }
        }
        
    }
    
}
