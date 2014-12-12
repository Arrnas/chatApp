//
//  Backend.swift
//  chatApp
//
//  Created by Arnas Dundulis on 12/10/14.
//  Copyright (c) 2014 Arnas Dundulis. All rights reserved.
//

import Foundation

class Backend {
    var access_token = ""
    let manager = AFHTTPRequestOperationManager(baseURL: NSURL(string:"https://chat-app-backend.herokuapp.com/v1/"))
    class var sharedInstance: Backend {
        struct Static {
            static let instance : Backend = Backend()
        }
        return Static.instance
    }
    
    init() {
        let params = ["username":"test","password":"pass"]
        manager.POST("login",
                    parameters: params,
                    success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                        let json = JSON(responseObject)
                        if let token = json["access_token"].string {
                            println("access token = \(token)")
                        } else {
                            println(json.error)
                        }
                        
                    },
                    failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                        println("Error: " + error.localizedDescription)
                    })
    }
}