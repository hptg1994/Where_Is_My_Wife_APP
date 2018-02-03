//
//  HomeViewController.swift
//  WifeRider
//
//  Created by 何品泰高 on 2018/1/16.
//  Copyright © 2018年 何品泰高. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation
import RevealingSplashView

class HomeViewController: UIViewController,MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var actionBtn: RoundedShadowButton!
    
    var delegate: CenterViewControllerDelegate?
    
    @IBOutlet weak var centerMapButton: UIButton!
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
        
        //observer to monitor the driver firebase
        DataService.instance.REF_DRIVERS.observe(.value) { (snapshot) in
            self.loadDriverAnnotationsFromFB()
        }
        
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.heartBeat
        revealingSplashView.startAnimation()
        revealingSplashView.heartAttack = true
    
    }
    @IBAction func centerMapButton(_ sender: UIButton) {
        centerMapOnUserLocation()
        centerMapButton.fadeTo(alphaValue: 0, withDuration: 0.2)
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
    
    func loadDriverAnnotationsFromFB() {
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value) { (snapshot) in
            if let driverSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for driver in driverSnapshot{
                    if driver.hasChild("userisDriver"){ // 这一个condition 要不要都可以，但是，driver也是一个passenger，所以当driver mode 的时候，passanger 的坐标也会更新
                        if driver.hasChild("coordinate"){
                            if driver.childSnapshot(forPath: "isPickupModeEnabled").value as? Bool == true{
                                if let driverDict = driver.value as? Dictionary<String,AnyObject>{
                                    let coordinateArray = driverDict["coordinate"] as! NSArray
                                    let driverCoordinate = CLLocationCoordinate2D(latitude: coordinateArray[0] as! CLLocationDegrees, longitude: coordinateArray[1] as! CLLocationDegrees)
                                    let annotation = DriverAnnotation(coordinate: driverCoordinate, withKey: driver.key)
                                    
                                    var driverIsVisible:Bool{
                                        return self.mapView.annotations.contains(where: { (annotation) -> Bool in
                                            if let driverAnnotation = annotation as? DriverAnnotation{
                                                if driverAnnotation.key == driver.key{
                                                    driverAnnotation.update(annotationPosition: driverAnnotation, withCoordinate: driverCoordinate)
                                                    return true
                                                }
                                            }
                                            return false
                                        })
                                    }
                                    if !driverIsVisible{
                                        self.mapView.addAnnotation(annotation)
                                    }
                                }
                            }else{
                                for annotation in self.mapView.annotations{
                                    if annotation.isKind(of: DriverAnnotation.self){
                                        if let annotation = annotation as? DriverAnnotation{
                                            if annotation.key == driver.key{
                                                self.mapView.removeAnnotation(annotation)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
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

//extension HomeViewController: UITextFieldDelegate{
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        <#code#>
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        <#code#>
//    }
//
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        <#code#>
//    }
//}


extension HomeViewController{
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        UpdateService.instance.updateUserLocation(withCoordinate: userLocation.coordinate)
        UpdateService.instance.updateDriverLocation(withCoordinate: userLocation.coordinate)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? DriverAnnotation {
            let identifier = "driver"
            var view : MKAnnotationView
            view =  MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.image = UIImage(named: "driverAnnotation")
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        centerMapButton.fadeTo(alphaValue: 1.0, withDuration: 0.2)
    }
}
