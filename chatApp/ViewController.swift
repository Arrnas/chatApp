//
//  ViewController.swift
//  chatApp
//
//  Created by Arnas Dundulis on 11/28/14.
//  Copyright (c) 2014 Arnas Dundulis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var prisijungimasTopVertical: NSLayoutConstraint!
    @IBOutlet weak var vardasTopVertical: NSLayoutConstraint!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
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
    
    @IBAction func login(sender: AnyObject) {
        view.endEditing(true)
        if ( !nameField.text.isEmpty && !passwordField.text.isEmpty ){
            backend.login(nameField.text, password: passwordField.text,
                callback: { success in
                    if(success) {
                        self.segwayToMainVC()
                    } else {
                        self.showErrorDialog()
                    }
                    })
        } else {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Some/All fields empty"
            alert.addButtonWithTitle("Oh noes")
            alert.show()
        }
    }
    
    func segwayToMainVC() {
        self.performSegueWithIdentifier("toTabVC", sender: self)
    }
    
    func showErrorDialog() {
        let alert = UIAlertView()
        alert.title = "Error"
        alert.message = "Login failed"
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
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        handleConstraints()
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
    
    func handleConstraints() {
        if (iOS7() && landscape()) {
            prisijungimasTopVertical.constant = 10
            vardasTopVertical.constant = 22
            containerHeight.constant = 324
        } else if (iOS7() && !landscape()) {
            prisijungimasTopVertical.constant = 20
            vardasTopVertical.constant = 62
            containerHeight.constant = 364
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        println("keyboard shown")
        //keyboard size = (320.0,0.0,162.0,568.0) landscape
        //keyboard size = (0.0,568.0,320.0,216.0) portrait
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            println("bottom inset = \(keyboardHeight(keyboardSize))")
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight(keyboardSize), right: 0)
            scrollView.contentInset = contentInsets
            //scrollToDisplayTextfield(keyboardSize)
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

