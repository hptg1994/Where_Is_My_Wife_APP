//
//  LeftSidePanelViewController.swift
//  WifeRider
//
//  Created by 何品泰高 on 2018/1/17.
//  Copyright © 2018年 何品泰高. All rights reserved.
//

import UIKit

class LeftSidePanelViewController: UIViewController {

    @IBAction func LoginSignUpBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        present(loginVC!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
