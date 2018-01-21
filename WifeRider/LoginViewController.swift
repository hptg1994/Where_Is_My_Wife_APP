    //
    //  LoginViewController.swift
    //  WifeRider
    //
    //  Created by 何品泰高 on 2018/1/18.
    //  Copyright © 2018年 何品泰高. All rights reserved.
    //

    import UIKit
    import Firebase

    class LoginViewController: UIViewController,UITextFieldDelegate{

        @IBOutlet weak var emailField: RoundedCornerTextField!
        @IBOutlet weak var passwordField: RoundedCornerTextField!
        @IBOutlet weak var segmentedControl: UISegmentedControl!
        
        @IBOutlet weak var authBtn: RoundedShadowButton!
        
        @IBAction func cancelBtn(_ sender: UIButton) {
            dismiss(animated: true, completion: nil)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            emailField.delegate = self
            passwordField.delegate = self
            view.bindtoKeyboard()
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
            self.view.addGestureRecognizer(tap)
        }
        
        @objc func handleScreenTap(sender:UIGestureRecognizer){
            self.view.endEditing(true)
        }
        
        @IBAction func authBtnPress(_ sender: Any) {
            if emailField.text != nil && passwordField.text != nil{
                authBtn.animateButton(shouldLoad: true, withMessage: nil)
                self.view.endEditing(true)
                
                if let email = emailField.text, let password = passwordField.text {
                    // 1.check if the user is already exist
                    Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                        if error == nil{
                            if let user = user{
                                if self.segmentedControl.selectedSegmentIndex == 0 {
                                    let userData = ["provider":user.providerID] as [String:Any]
                                    DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: false)
                                }else{
                                    let userData = ["provider":user.providerID,"userisDriver":true,"isPickupModeEnabled":false,"driverIsOnTrips":false] as [String : Any]
                                    DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: true)
                                }
                            }
                            print("Email User authenticated successfully eith Firebase")
                            self.dismiss(animated: true, completion: nil)
                        }else{
                            // 2.user not exist
                            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                                //handle the error
                                if error != nil {
                                    if let errorCode = AuthErrorCode(rawValue: error!._code){
                                        switch errorCode{
                                        case .invalidEmail:
                                            print("Emial invalid.Please try again.")
                                        case .emailAlreadyInUse:
                                            print("That email is already in use.Please try again")
                                        case .wrongPassword:
                                            print("Whoops!That was the wrong password!")
                                        default:
                                            print("An unxpected error occured.Please try again.")
                                        }
                                    }
                                }else{
                                    //valid create the user
                                    if let user = user {
                                        if self.segmentedControl.selectedSegmentIndex == 0{
                                            let userData = ["provider":user.providerID] as [String:Any] // 会按照这个格式创建Database数据
                                            DataService.instance.createFirebaseDBUser(uid: user.uid ,userData: userData, isDriver: false)
                                        }else{
                                            let userData = ["provider":user.providerID,"userIsDriver":true,"isPickupModeEnabled":false,"driverIsOnTrip":false] as [String : Any]
                                            DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: true)
                                        }
                                    }
                                    print("Successfully created a new user with firebase")
                                    self.dismiss(animated: true, completion: nil)
                                }
                            })
                        }
                    })
                }
            }
        }
    }
