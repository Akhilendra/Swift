//
//  TravellingConstants.swift
//  Travelling
//
//  Created by Muskan on 8/12/16.
//  Copyright © 2016 Muskan. All rights reserved.
//

import Foundation

struct TravellingConstants {
    // MARK: Services
    struct Services {
        struct Dride {
            static let server = "staging.app-api.dride.in/api/v1/"
            static let baseURL = "http://" + TravellingConstants.Services.Dride.server
        }
    }
    
    struct urls {
        static let contact = "http://staging.app-api.dride.in/api/v1/contact"
        static let users = "http://staging.app-api.dride.in/api/v1/users"
        static let verify = "http://staging.app-api.dride.in/api/v1/verify"
        static let products = "http://staging.app-api.dride.in/api/v1"
        static let locations = "http://staging.app-api.dride.in/api/v1/locations"
        static let history = "http://staging.app-api.dride.in/api/v1/history"
        static let trip = "http://staging.app-api.dride.in/api/v1/trip"
    }
    
    //MARK:-Error
    struct ErrorStrings {
        static let internalError = "Internal Error Occurred"
        static let reachabilityError = "Internet not available"
    }
    
    //MARK:- StoryBoard Ids
    struct StoryBoard {
        static let MapViewController = "MapViewController"
        static let LoggedInViewController = "LoggedInViewController"
        static let TravellingMobileDetailsViewController = "TravellingMobileDetailsViewController"
        static let LoginViewController = "LoginViewController"
        static let TravellingOTPScreenViewController = "TravellingOTPScreenViewController"
    }
    
    //MARK:- NSUserDefaultsIDs
    struct NSUserDefaults {
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let loginWithMobile = "loginWithMobile"
        static let onesignal_userId = "onesignal_userId"
        static let user_mobile = "mobile"
        static let username = "uname"
        static let user_email = "uemail"
        static let user_pic = "upic"
        static let userId = "uid"
        //static let googleid = "gid"
        static let placeTitleArray = "placeTitle"
        static let placeDetailArray = "placeDetail"
        static let placeLatArray = "placeLat"
        static let placeLonArray = "placeLon"
    }
}
















