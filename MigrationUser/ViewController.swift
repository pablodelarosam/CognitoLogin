//
//  ViewController.swift
//  MigrationUser
//
//  Created by Pablo de la Rosa Michicol on 5/1/19.
//  Copyright © 2019 CraftCode. All rights reserved.
//

import UIKit
import AWSMobileClient

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.signUp()
        //self.signIn()
        signInf()
    }
    override func viewWillAppear(_ animated: Bool) {
        signInf()

    }
    
    @IBAction func logout(_ sender: Any) {
        AWSMobileClient.sharedInstance().signOut()
        signInf()
    }
    private func signInf() {
        if AWSMobileClient.sharedInstance().isSignedIn{
            
        } else {
            guard let navController = self.navigationController else {
                return
            }
            AWSMobileClient.sharedInstance().showSignIn(navigationController: navController,
                                                        signInUIOptions: SignInUIOptions(
                                                            canCancel: false,
                                                            logoImage: UIImage(named: "iconVW"),
                                                            backgroundColor: UIColor.black)) {
                                                                (userState, error) in
                                                                
                                                                guard error == nil else {
                                                                    return
                                                                }
                                                                guard userState != nil else {
                                                                    return
                                                                }
                                                                
                                                                if userState == .signedIn {
                                                                    print("success")
                                                                    
                                                                 //   self.doInvokeAPI()
                                                                    
                                                                    print(AWSMobileClient.sharedInstance().username ?? "no user name")
                                                                    
                                                                    if let user = AWSMobileClient.sharedInstance().username {
                                                                        //Constants.storeUserName(username: user )
                                                                        //self.usernameLabel.text = "Welcome, \(user ?? "")"
                                                                        
                                                                        
                                                                    }
                                                                }
            }
        }
    }
    
    func getUserState(){
        AWSMobileClient.sharedInstance().initialize { (userState, error) in
            if let userState = userState {
                print("UserState: \(userState.rawValue)")
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    func signIn(){
        AWSMobileClient.sharedInstance().signIn(username: "your_username", password: "Abc@123!") { (signInResult, error) in
            if let error = error  {
                print("\(error.localizedDescription)")
            } else if let signInResult = signInResult {
                switch (signInResult.signInState) {
                case .signedIn:
                    print("User is signed in.")
                    self.getUserState()
                case .smsMFA:
                    print("SMS message sent to \(signInResult.codeDetails!.destination!)")
                default:
                    print("Sign In needs info which is not et supported.")
                }
            }
        }
    }
    
    func signUp(){
        AWSMobileClient.sharedInstance().signUp(username: "your_username",
                                                password: "Abc@123!",
                                                userAttributes: ["email":"john@doe.com", "phone_number": "+1973123456"]) { (signUpResult, error) in
                                                    if let signUpResult = signUpResult {
                                                        switch(signUpResult.signUpConfirmationState) {
                                                        case .confirmed:
                                                            print("User is signed up and confirmed.")
                                                            self.signIn()
                                                        case .unconfirmed:
                                                            print("User is not confirmed and needs verification via \(signUpResult.codeDeliveryDetails!.deliveryMedium) sent at \(signUpResult.codeDeliveryDetails!.destination!)")
                                                        case .unknown:
                                                            print("Unexpected case")
                                                        }
                                                    } else if let error = error {
                                                        if let error = error as? AWSMobileClientError {
                                                            switch(error) {
                                                            case .usernameExists(let message):
                                                                print(message)
                                                            default:
                                                                break
                                                            }
                                                        }
                                                        print("\(error.localizedDescription)")
                                                    }
        }
    }
}



