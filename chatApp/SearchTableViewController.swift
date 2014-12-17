//
//  SearchTableViewController.swift
//  chatApp
//
//  Created by Arnas Dundulis on 12/17/14.
//  Copyright (c) 2014 Arnas Dundulis. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController,UISearchBarDelegate,UISearchDisplayDelegate {
    let backend = Backend.sharedInstance
    var foundUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
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
        if (foundUser == nil) {
            return 0
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("searchCell") as UITableViewCell
        if (foundUser != nil) {
            cell.textLabel!.text! = foundUser!.username
        } else {
            cell.textLabel!.text! = "empty"
        }

        return cell
    }

    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        backend.fetchUser(searchString, callback: {success,user in if(success) { self.foundUser = user
            println("found da user")
            controller.searchResultsTableView.reloadData()
            self.tableView.reloadData()
            } })
        return false
    }
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let userViewController = segue.destinationViewController as UserAddDetailViewController
        userViewController.user = foundUser
    }


}
