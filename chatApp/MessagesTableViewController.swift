//
//  MessagesTableViewController.swift
//  chatApp
//
//  Created by Arnas Dundulis on 12/17/14.
//  Copyright (c) 2014 Arnas Dundulis. All rights reserved.
//

import UIKit

class MessagesTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var textField: UITextField!
    let backend = Backend.sharedInstance
    var messages = [Message]()
    var group:Group?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        messages = [Message]()
        fetch()
    }
    
    func fetch() {
        backend.fetchMessages(group!.id, callback: { success,message in if(success) { self.messages.append(message!); self.tableView.reloadData() } })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("messageCell") as UITableViewCell
        if (indexPath.row < messages.count) {
            cell.detailTextLabel!.text! = messages[indexPath.row].message_body
            for user: User in group!.users {
                if (user.id == messages[indexPath.row].author) {
                    cell.textLabel!.text! = user.username
                    break
                }
            }
            
        }
        return cell
    }
    
    func showError() {
        let alert = UIAlertView()
        alert.title = "Error"
        alert.message = "failed to send message"
        alert.addButtonWithTitle("Oh noes")
        alert.show()
    }
    
    @IBAction func sendMessage(sender: AnyObject) {
        if(textField.text != nil && !textField.text.isEmpty) {
            backend.sendMessage(textField.text!, group_id: group!.id, callback: {success in if(success){ self.fetch() } else { self.showError()} })
        }
    }
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        let userViewController = segue.destinationViewController as UserAddDetailViewController
    //        userViewController.user = foundUser
    //    }
}
