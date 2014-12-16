//
//  RegisterViewController.swift
//  chatApp
//
//  Created by Arnas Dundulis on 12/16/14.
//  Copyright (c) 2014 Arnas Dundulis. All rights reserved.
//

import Foundation

//
//  ViewController.swift
//  chatApp
//
//  Created by Arnas Dundulis on 11/28/14.
//  Copyright (c) 2014 Arnas Dundulis. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmation: UITextField!
    
    let backend = Backend.sharedInstance;
    var selectedFieldsYPos : CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction func cancelModal(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func register(sender: AnyObject) {
        if (!nameField.text.isEmpty && !emailField.text.isEmpty && !passwordField.text.isEmpty && !passwordConfirmation.text.isEmpty) {
            backend.register(nameField.text, password: passwordField.text, passConfirm: passwordConfirmation.text, email: emailField.text, callback: { success in
                if (success) { self.login() }
                else { self.showErrorDialog() }
            })
        } else {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Some/All fields empty"
            alert.addButtonWithTitle("Oh noes")
            alert.show()
        }
    }
    
    func login() {
        backend.login(nameField.text, password: passwordField.text, callback: { success in
            if(success) {
                self.segwayToMainVC()
            } else {
                self.showErrorDialog()
            }
        })
    }
    
    func segwayToMainVC() {
        self.performSegueWithIdentifier("toTabVC", sender: self)
    }
    
    func showErrorDialog() {
        let alert = UIAlertView()
        alert.title = "Error"
        alert.message = "Registration failed"
        alert.addButtonWithTitle("Oh noes")
        alert.show()
    }
    
    @IBAction func textfieldEditingBegan(sender: AnyObject) {
        let fieldOrigin = sender.frame.origin
        let fieldSize = sender.frame.size
        println("selected field origin \(fieldSize)")
        selectedFieldsYPos = fieldOrigin.y + fieldSize.height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func iOS7() -> Bool {
        switch UIDevice.currentDevice().systemVersion.compare("8.0.0", options: NSStringCompareOptions.NumericSearch) {
        case .OrderedSame, .OrderedDescending:
            //iOS >= 8.0
            return false
        case .OrderedAscending:
            //iOS < 8.0
            return true
        }
    }
    
    func landscape() -> Bool {
        if ( UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft || UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight ) {
            return true
        }
        return false
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        println("keyboard shown")
        //keyboard size = (320.0,0.0,162.0,568.0) landscape
        //keyboard size = (0.0,568.0,320.0,216.0) portrait
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            println("bottom inset = \(keyboardHeight(keyboardSize))")
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight(keyboardSize), right: 0)
            scrollView.contentInset = contentInsets
            scrollToDisplayTextfield(keyboardSize)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        println("keyboard hidden")
        scrollView.contentInset = UIEdgeInsetsZero
    }
    
    func keyboardHeight(keyboardRect: CGRect) -> CGFloat {
        return landscape() ? keyboardRect.width : keyboardRect.height
    }
    
    func viewHeight() -> CGFloat { // TODO: ios8 screen size depends on orientation http://stackoverflow.com/questions/24150359/is-uiscreen-mainscreen-bounds-size-becoming-orientation-dependent-in-ios8
        return landscape() ? view.frame.width : view.frame.height
    }
    
    func scrollToDisplayTextfield(keyboardSize: CGRect) {
        if let fieldYPoint = selectedFieldsYPos {
            let visibleYSpace = view.frame.height - keyboardSize.height
            let padding : CGFloat = 10.0
            let offsetWithPadding = (fieldYPoint - visibleYSpace) + padding
            println("view heigh = \(view.frame.height) keyboard height = \(keyboardHeight(keyboardSize)) field position = \(fieldYPoint)")
            println("offset with padding = \(offsetWithPadding)")
            let point = CGPoint(x: 0, y:  offsetWithPadding)
            scrollView.setContentOffset(point, animated: true)
        }
    }
    
    
}

