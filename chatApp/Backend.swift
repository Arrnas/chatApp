//
//  Backend.swift
//  chatApp
//
//  Created by Arnas Dundulis on 12/10/14.
//  Copyright (c) 2014 Arnas Dundulis. All rights reserved.
//

import Foundation

class Backend {
    var username : String = ""
    var password : String = ""
    var access_token : String = ""
    let manager = AFHTTPRequestOperationManager()
    
    init() {
    }
}