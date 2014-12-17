//
//  Group.swift
//  chatApp
//
//  Created by Arnas Dundulis on 12/17/14.
//  Copyright (c) 2014 Arnas Dundulis. All rights reserved.
//

import Foundation

class Group {
    var id = ""
    var title = ""
    var users = [User]()
    
    init(id: String,title: String,user_ids: [User]) {
        self.id = id
        self.title = title
        self.users = user_ids
    }
}