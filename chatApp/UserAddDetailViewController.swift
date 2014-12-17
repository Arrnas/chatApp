//
//  UserAddDetailViewController.swift
//  chatApp
//
//  Created by Arnas Dundulis on 12/17/14.
//  Copyright (c) 2014 Arnas Dundulis. All rights reserved.
//

import UIKit

class UserAddDetailViewController: UIViewController {
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var emailField: UILabel!
    var user: User?
    let backend = Backend.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear(animated: Bool) {
        if( user != nil) {
            nameField.text = user?.username
            emailField.text = user?.email
        }
    }
    
    @IBAction func addFriend(sender: AnyObject) {
        if(user != nil) {
            backend.addFriend(user!.id, callback: { success in
                if(success) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else { 
                    self.displayError()
                }
            })
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
