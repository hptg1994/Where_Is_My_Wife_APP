//
//  DataService.swift
//  WifeRider
//
//  Created by 何品泰高 on 2018/1/19.
//  Copyright © 2018年 何品泰高. All rights reserved.
//

import Foundation
import Firebase


var DB_BASE = Database.database().reference()

class DataService{

    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_DRIVERS = DB_BASE.child("drivers")
    private var _REF_TRIPS = DB_BASE.child("trips")
    static let instance = DataService()
    
    var REF_BASE : DatabaseReference{
        
        return _REF_BASE
    }
    
    var REF_USERS:DatabaseReference{
        return _REF_USERS
    }
    
    var REF_DRIVERS:DatabaseReference{
        return _REF_DRIVERS
    }
    
    var REF_TRIPS:DatabaseReference{
        return _REF_TRIPS
    }
    
    func createFirebaseDBUser(uid:String,userData:Dictionary<String,Any>,isDriver:Bool){
        if isDriver{
            REF_DRIVERS.child(uid).updateChildValues(userData)
        } else {
            REF_USERS.child(uid).updateChildValues(userData)
        }
    }
    
    
}
