//
//  GroupTableViewController.swift
//  chatApp
//
//  Created by Arnas Dundulis on 12/17/14.
//  Copyright (c) 2014 Arnas Dundulis. All rights reserved.
//

import UIKit

class GroupTableViewController: UITableViewController {
    let backend = Backend.sharedInstance
    var groups = [Group]()
    var selectedGroup:Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        groups = [Group]()
        backend.fetchGroups({success,group in if(success) { self.groups.append(group!); self.tableView.reloadData()}})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("groupCell") as UITableViewCell
        if (indexPath.row < groups.count) {
            cell.textLabel!.text! = groups[indexPath.row].title
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedGroup = groups[indexPath.row]
        self.performSegueWithIdentifier("showMessages", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let messagesViewController = segue.destinationViewController as MessagesTableViewController
        messagesViewController.group = selectedGroup
    }
}
