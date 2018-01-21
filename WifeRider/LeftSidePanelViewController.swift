//
//  LeftSidePanelViewController.swift
//  WifeRider
//
//  Created by 何品泰高 on 2018/1/17.
//  Copyright © 2018年 何品泰高. All rights reserved.
//

import UIKit
import Firebase

class LeftSidePanelViewController: UIViewController {
    
    let appDelegate = AppDelegate.getAppDelegate()
    
    let currentUserId = Auth.auth().currentUser?.uid

    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userAccountTypeLabel: UILabel!
    @IBOutlet weak var userImageView: RoundImageView!
    @IBOutlet weak var loginOutButton: UIButton!
    @IBOutlet weak var pickupModeSwitchButton: UISwitch!
    @IBOutlet weak var pickupModeLabel: UILabel!
    
    @IBAction func LoginSignUpBtn(_ sender: UIButton) {
        if Auth.auth().currentUser == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
            present(loginVC!, animated: true, completion: nil)
        }else{
            do{
                try Auth.auth().signOut()
                userEmailLabel.text = ""
                userAccountTypeLabel.text = ""
                userImageView.isHidden = true
                pickupModeLabel.text = ""
                pickupModeSwitchButton.isHidden = true
                loginOutButton.setTitle("Sign Up / Login", for: .normal)
            }catch(let error){
                print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) 
        pickupModeSwitchButton.isOn = false
        pickupModeSwitchButton.isHidden = true
        pickupModeLabel.isHidden = true
        observePassengersAndDrivers()
        
        if Auth.auth().currentUser == nil {
            userEmailLabel.text = ""
            userAccountTypeLabel.text = ""
            userImageView.isHidden = true
            loginOutButton.setTitle("Sign Up/ Login", for: .normal)
        }else{
            userEmailLabel.text = Auth.auth().currentUser?.email
            userAccountTypeLabel.text = ""
            userImageView.isHidden = false
            loginOutButton.setTitle("Logout", for: .normal)
        }
    }
    
    func observePassengersAndDrivers(){
        DataService.instance.REF_USERS.observeSingleEvent(of: .value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if snap.key == Auth.auth().currentUser?.uid{
                        self.userAccountTypeLabel.text = "PASSENGER"
                    }
                }
            }
        }
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value ,with: {(snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if snap.key == Auth.auth().currentUser?.uid{
                        self.userAccountTypeLabel.text = "DRIVER"
                        self.pickupModeSwitchButton.isHidden = false
                        let switchStatus = snap.childSnapshot(forPath: "isPickupModeEnabled").value as! Bool
                        self.pickupModeSwitchButton.isOn = switchStatus
                        self.pickupModeLabel.isHidden = false
                    }
                }
            }
        })
    }
    
    @IBAction func pickUpSwitchToggle(_ sender: UIButton) {
        if pickupModeSwitchButton.isOn {
            pickupModeLabel.text = "PICKUP MODE ENABLE"
            appDelegate.menuContainerVC.toggleLeftPanel()
            DataService.instance.REF_DRIVERS.child(currentUserId!).updateChildValues(["isPickupModeEnabled" :true])
        }else{
            pickupModeLabel.text = "PICKUP MODE DISABLE"
            appDelegate.menuContainerVC.toggleLeftPanel()
            DataService.instance.REF_DRIVERS.child(currentUserId!).updateChildValues(["isPickupModeEnabled":false])
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
