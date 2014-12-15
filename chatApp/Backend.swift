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
    
    func login(username: String,password: String) {
        let params = ["username":username,"password":password]
        manager.POST("login",
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                let json = JSON(responseObject)
                if let token = json["access_token"].string {
                    self.access_token = token
                } else {
                    println(json.error)
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
    }
    func register(username: String,password: String,email: String,callback: (success:Bool)->()) {
        let UUID = NSUUID().UUIDString
        let params = ["username":username,"password":password,"email":email,"deviceid":UUID]
        manager.POST("users",
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                if (operation.response.statusCode == 201) {
                    callback(success: true)
                } else {
                    callback(success: false)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
                callback(success: false)
        })
    }
}