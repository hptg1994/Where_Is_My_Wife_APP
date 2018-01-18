//
//  LoginViewController.swift
//  WifeRider
//
//  Created by 何品泰高 on 2018/1/18.
//  Copyright © 2018年 何品泰高. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindtoKeyboard()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleScreenTap(sender:UIGestureRecognizer){
        self.view.endEditing(true)
    }
    

}
