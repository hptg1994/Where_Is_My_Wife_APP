//
//  HomeViewController.swift
//  WifeRider
//
//  Created by 何品泰高 on 2018/1/16.
//  Copyright © 2018年 何品泰高. All rights reserved.
//

import UIKit
import MapKit
class HomeViewController: UIViewController,MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var actionBtn: RoundedShadowButton!
    
    var delegate: CenterViewControllerDelegate?
    
    @IBAction func actionBtnWasPressed(_ sender: Any) {
        actionBtn.animateButton(shouldLoad: true, withMessage: nil)
    }
    
    @IBAction func PressMenu(_ sender: Any) {
        delegate?.toggleLeftPanel()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
}

