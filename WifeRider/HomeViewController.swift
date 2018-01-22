//
//  HomeViewController.swift
//  WifeRider
//
//  Created by 何品泰高 on 2018/1/16.
//  Copyright © 2018年 何品泰高. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RevealingSplashView

class HomeViewController: UIViewController,MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var actionBtn: RoundedShadowButton!
    
    var delegate: CenterViewControllerDelegate?
    
    var manager:CLLocationManager?
    
    var regionRadius:CLLocationDistance = 1000
    
    let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "launchScreenIcon")!, iconInitialSize: CGSize(width: 80, height: 80), backgroundColor: UIColor.white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationAuthStatus()
        mapView.delegate = self
        centerMapOnUserLocation()
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.heartBeat
        revealingSplashView.startAnimation()
        revealingSplashView.heartAttack = true
    }
    @IBAction func centerMapButton(_ sender: UIButton) {
        centerMapOnUserLocation()
    }
    
    @IBAction func actionBtnWasPressed(_ sender: Any) {
        actionBtn.animateButton(shouldLoad: true, withMessage: nil)
    }
    
    @IBAction func PressMenu(_ sender: Any) {
        delegate?.toggleLeftPanel()
    }
    
    func checkLocationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedAlways{
            manager?.startUpdatingLocation()
        }else{
            manager?.requestAlwaysAuthorization()
        }
    }
    
    func centerMapOnUserLocation(){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

//这个相当于是告诉 Delegate 要干什么
extension HomeViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthStatus()
        if status == .authorizedAlways{
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
    }
}
