//
//  TravellingError.swift
//  Travelling
//
//  Created by Muskan on 8/13/16.
//  Copyright © 2016 Muskan. All rights reserved.
//

import Foundation

class TravellingError {
    var statusCode:Int!
    var message:String!
    
    init(json: JSON) {
        self.statusCode = json["status_code"].int!
        self.message = json["message"].string!
    }
    
    init(statusCode:Int, message:String) {
        self.statusCode = statusCode
        self.message = message
    }
}
