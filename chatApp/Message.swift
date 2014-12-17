//
//  Message.swift
//  chatApp
//
//  Created by Arnas Dundulis on 12/17/14.
//  Copyright (c) 2014 Arnas Dundulis. All rights reserved.
//

import Foundation

class Message {
    var message_body = ""
    var time = ""
    var id = ""
    var author = ""
    init(message: String,time: String,id: String,author: String){
        self.message_body = message
        self.time = time
        self.id = id
        self.author = author
    }
}