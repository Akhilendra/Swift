//
//  ShareData.swift
//
//  Created by Muskan on 8/16/16.
//  Copyright © 2016 Muskan. All rights reserved.
//

import Foundation

class ShareData {
    class var sharedInstance: ShareData {
        struct Static {
            static var instance: ShareData?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = ShareData()
        }
        
        return Static.instance!
    }
    
    
    var someString : String! //Some String
    
    var selectedTheme : AnyObject! //Some Object
    
    var someBoolValue : Bool!
    
    var selection : Int = 0
    
    var NumberofRows: Int!
    var display_nameArray = [String]()
    var companyArray = [String]()
    var minimumArray = [String]()
    var cost_per_distanceArray = [String]()
    var base_fareArray = [String]()
    var cancellation_feeArray = [String]()
    var cost_per_minuteArray = [String]()
    var surge_multiplierArray = [String]()
    var ride_estimate_minArray = [String]()
    var ride_estimate_maxArray = [String]()
    var etaArray = [String]()
}

class AutoShareData {
    class var sharedInstance: AutoShareData {
        struct Static {
            static var instance: AutoShareData?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = AutoShareData()
        }
        
        return Static.instance!
    }
    
    
    var someString : String! //Some String
    
    var selectedTheme : AnyObject! //Some Object
    
    var someBoolValue : Bool!
    
    var NumberofRows: Int!
    var display_nameArray = [String]()
    var companyArray = [String]()
    var minimumArray = [String]()
    var cost_per_distanceArray = [String]()
    var base_fareArray = [String]()
    var cancellation_feeArray = [String]()
    var cost_per_minuteArray = [String]()
    var surge_multiplierArray = [String]()
    var ride_estimate_minArray = [String]()
    var ride_estimate_maxArray = [String]()
    var etaArray = [String]()
}

