//
//  FriendsTableViewController.swift
//  chatApp
//
//  Created by Arnas Dundulis on 12/16/14.
//  Copyright (c) 2014 Arnas Dundulis. All rights reserved.
//

import Foundation

class FriendsTableViewController:UITableViewController {
    let backend = Backend.sharedInstance
    override func viewDidLoad() {
        backend.fetchFriends(nil)
    }
}