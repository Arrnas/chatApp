//
//  UserGroupViewController.swift
//  chatApp
//
//  Created by Arnas Dundulis on 12/17/14.
//  Copyright (c) 2014 Arnas Dundulis. All rights reserved.
//

import UIKit

class UserGroupViewController: UIViewController {
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var emailField: UILabel!
    var user: User?
    let backend = Backend.sharedInstance
    
    override func viewWillAppear(animated: Bool) {
        if(user != nil) {
            nameField.text = user?.username
            emailField.text = user?.email
        }
    }
    @IBAction func createGroup(sender: AnyObject) {
        if(user != nil) {
            backend.createGroup(user!.username, friendID: user!.id, callback: {success in if(success) { self.navigationController?.popToRootViewControllerAnimated(true) } else { self.displayError() } })
        }
    }
    
    func displayError() {
        let alert = UIAlertView()
        alert.title = "Error"
        alert.message = "failed to add friend"
        alert.addButtonWithTitle("Oh noes")
        alert.show()
    }
}
