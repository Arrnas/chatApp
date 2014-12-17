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
    
    func login(username: String,password: String,callback: (success:Bool)->()) {
        let params = ["username":username,"password":password]
        manager.POST("login",
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                let json = JSON(responseObject)
                if let token = json["access_token"].string {
                    self.access_token = token
                    callback(success: true)
                } else {
                    println(json.error)
                    callback(success: false)
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
                callback(success: false)
        })
    }
    func register(username: String,password: String,passConfirm: String,email: String,callback: (success:Bool)->()) {
        let UUID = NSUUID().UUIDString
        println("UUID = \(UUID)")
        let user = ["username":username,"password":password,"password_confirmation":passConfirm,"email":email,"deviceid":UUID]
        let params = ["user":user]
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
    func fetchFriends(callback: ((success: Bool,user: User?) -> ())?) {
        manager.GET("friends?access_token=\(access_token)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                if (operation.response.statusCode == 200) {
                    println("response: \(responseObject)")
                    if(callback != nil) {
                        let json = JSON(responseObject)
                        for (key: String,subJson: JSON) in json {
                            println("subjson = \(subJson)")
                            let userID = subJson["friend_id"]["$oid"].string
                            self.fetchUserByID(userID!, callback: {success,user in if(success) { callback!(success: success,user: user) } })
                        }
                    }
                } else {
                    if((callback) != nil) { callback!(success: false,user:nil) }
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
                if((callback) != nil) { callback!(success: false,user:nil) }
        })
    }
    func fetchUserByID(id:String,callback: ((success: Bool,user: User?) -> ())?) {
        manager.GET("users/\(id)?access_token=\(access_token)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                if (operation.response.statusCode == 200) {
                    println("response: \(responseObject)")
                    let json = JSON(responseObject)
                    let username = json["username"].string
                    let email = json["email"].string
                    let id = json["_id"]["$oid"].string
                    let user = User(username: username!, email: email!, id: id!) as User?
                    if((callback) != nil) { callback!(success: true,user: user) }
                } else {
                    if((callback) != nil) { callback!(success: false,user: nil) }
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
                if((callback) != nil) { callback!(success: false,user: nil) }
        })
    }
    func fetchUser(var username:String,callback: ((success: Bool,user: User?) -> ())?) {
        username = username.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        manager.GET("username/\(username)?access_token=\(access_token)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                if (operation.response.statusCode == 200) {
                    println("response: \(responseObject)")
                    let json = JSON(responseObject)
                    let username = json["username"].string
                    let email = json["email"].string
                    let id = json["_id"]["$oid"].string
                    let user = User(username: username!, email: email!, id: id!) as User?
                    if((callback) != nil) { callback!(success: true,user: user) }
                } else {
                    if((callback) != nil) { callback!(success: false,user: nil) }
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
                if((callback) != nil) { callback!(success: false,user: nil) }
        })
    }
    func addFriend(friendID: String,callback: (success:Bool)->()) {
        let friendship = ["friend_id":friendID]
        let params = ["friendship":friendship]
        manager.POST("friends?access_token=\(access_token)",
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
    func createGroup(title:String,friendID: String,callback: (success:Bool)->()) {
        let group = ["user_ids":[friendID],"title":title]
        let params = ["group":group]
        manager.POST("groups?access_token=\(access_token)",
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
                println("fail response: \(operation.responseString)")
                callback(success: false)
        })
    }
    func fetchGroups(callback: ((success: Bool,group: Group?) -> ())?) {
        manager.GET("groups?access_token=\(access_token)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                if (operation.response.statusCode == 200) {
                    println("response: \(responseObject)")
                    if(callback != nil) {
                        let json = JSON(responseObject)
                        for (key: String,subJson: JSON) in json {
                            println("subjson = \(subJson)")
                            let groupID = subJson["_id"]["$oid"].string
                            let title = subJson["title"].string
                            var user_ids = [User]()
                            for (key: String,subJson: JSON) in subJson["user_ids"] {
                                let user_id = subJson["$oid"].string
                                self.fetchUserByID(user_id!, callback: {success,user in
                                    if(success) {
                                        user_ids.append(user!)
                                    }
                                })
                            }
                            let group = Group(id: groupID!, title: title!, user_ids: user_ids)
                            if(callback != nil) {
                                callback!(success:true,group: group)
                            }
                        }
                    }
                } else {
                    if((callback) != nil) { callback!(success: false,group:nil) }
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
                if((callback) != nil) { callback!(success: false,group:nil) }
        })
    }
    func fetchMessages(groupID: String,callback: ((success: Bool,message: Message?) -> ())?) {
        manager.GET("groups/\(groupID)/messages?access_token=\(access_token)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                if (operation.response.statusCode == 200) {
                    println("response: \(responseObject)")
                    if(callback != nil) {
                        let json = JSON(responseObject)
                        for (key: String,subJson: JSON) in json {
                            let message_body = subJson["message_body"].string
                            let timestamp = subJson["timestamp"].string
                            let author = subJson["author_id"]["$oid"].string
                            let id = subJson["_id"]["$oid"].string
                            let message = Message(message: message_body!, time: timestamp!, id: id!, author: author!)
                            if (callback != nil) { callback!(success:true,message:message) }
                        }
                    }
                } else {
                    if((callback) != nil) { callback!(success: false,message:nil) }
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
                if((callback) != nil) { callback!(success: false,message:nil) }
        })
    }
    func sendMessage(message:String,group_id: String,callback: (success:Bool)->()) {
        let message = ["message_body":message]
        let params = ["message":message]
        manager.POST("groups/\(group_id)/messages?access_token=\(access_token)",
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
                println("fail response: \(operation.responseString)")
                callback(success: false)
        })
    }
}