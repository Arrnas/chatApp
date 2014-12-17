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
    var friends = [User]()
    var selectedUser : User?
    override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    override func viewWillAppear(animated: Bool) {
        friends = [User]()
        backend.fetchFriends({success,user in if(success){ self.friends.append(user!); self.tableView.reloadData() }})
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.row < friends.count) {
            selectedUser = friends[indexPath.row]
            self.performSegueWithIdentifier("detailGroup", sender: self)
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row //get the array index from the index path
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) as UITableViewCell //make the cell
        if(indexPath.row < friends.count) {
            cell.textLabel!.text! = friends[indexPath.row].username
            cell.detailTextLabel!.text! = friends[indexPath.row].email
        }
        return cell
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "detailGroup") {
            let userGroupDetail = segue.destinationViewController as UserGroupViewController
            userGroupDetail.user = selectedUser
        }
    }
}