//
//  SettingsPersonalInfoViewController.swift
//  Pedometer
//
//  Created by Dan Neatu on 17.10.14.
//  Copyright (c) 2014 FH-Hagenberg. All rights reserved.
//

import Foundation
import UIKit

class SettingsPersonalInfoViewController : UIViewController, UITextFieldDelegate {
    var userDefaults = NSUserDefaults.standardUserDefaults()
    var app = AppSingletonClass.sharedSingletonInstance()
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    let imgMaleEnabled = UIImage(named: "ic_male_enabled")
    let imgMaleDisabled = UIImage(named: "ic_male_disabled")

    let imgFemaleEnabled = UIImage(named: "ic_woman_enabled")
    let imgFemaleDisabled = UIImage(named: "ic_woman_disabled")

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfAge: UITextField!
    @IBOutlet weak var tfHeight: UITextField!
    @IBOutlet weak var tfWeight: UITextField!
    @IBOutlet weak var btnMaleOutlet: UIButton!
    @IBOutlet weak var btnFemaleOutlet: UIButton!

    
    @IBAction func btnMale(sender: AnyObject) {
        btnMaleOutlet.setImage(imgMaleEnabled, forState: UIControlState.Normal)
        btnFemaleOutlet.setImage(imgFemaleDisabled, forState: UIControlState.Normal)
        app.male = true
        app.female = false
    }
    @IBAction func btnFemale(sender: AnyObject) {
        btnFemaleOutlet.setImage(imgFemaleEnabled, forState: UIControlState.Normal)
        btnMaleOutlet.setImage(imgMaleDisabled, forState: UIControlState.Normal)
        app.female = true
        app.male = false
    }


    override func viewDidLoad() {

        if(app.male){
            btnMaleOutlet.setImage(imgMaleEnabled, forState: UIControlState.Normal)
            btnFemaleOutlet.setImage(imgFemaleDisabled, forState: UIControlState.Normal)
        }else{
            btnFemaleOutlet.setImage(imgFemaleEnabled, forState: UIControlState.Normal)
            btnMaleOutlet.setImage(imgMaleDisabled, forState: UIControlState.Normal)
        }
        
        tfName.delegate = self
        tfAge.delegate = self
        tfHeight.delegate = self
        tfWeight.delegate = self
        
        //initilize textfileds with data from app-model
        tfName.text = app.name
        tfAge.text = String(app.age)
        tfHeight.text = String(app.height)
        tfWeight.text = String(format:"%.1f", app.weight)
    }
    

    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        if(self.checkIfValidNumber(tfAge.text)){
            if(tfAge.text.toInt()>0 && tfAge.text.toInt()<100){
                app.age = tfAge.text.toInt()!
            }
        }
        if(self.checkIfValidDouble(tfWeight.text).0){ //.0 return type is bool
            app.weight = self.checkIfValidDouble(tfWeight.text).1 //.1 return type is double
        }
        if(self.checkIfValidNumber(tfHeight.text)){
            if(tfHeight.text.toInt()>90 && tfHeight.text.toInt()<240){
                app.height = tfHeight.text.toInt()!
            }
        }
        app.name = tfName.text
        appDelegate.saveAllData()
        
        //remove keyboard after pressing enter button
        textField.resignFirstResponder()
        return true;
    }

    
    func checkIfValidNumber(number: String) -> Bool
    {
        var num = number.toInt()
        if num != nil {
            //valid number
            return true
        }
        else {
            //valid number
            return false
        }
    }
    
    func checkIfValidDouble(doublenumber: String) -> (Bool,Double)
    {
        var f:NSNumberFormatter = NSNumberFormatter()
        if(f.numberFromString(doublenumber) == nil){
            return (false, 0.0)
        }else{
            var n:NSNumber = f.numberFromString(doublenumber)!
            var string = NSString(string: doublenumber)
            if(string.doubleValue>20||string.doubleValue<400){ //string.doubleValue converts a string to double
                //invalid double
                return (false, 0.0)
            }else{
                //valid double
                return (true, string.doubleValue)
            }
        }
    }
    

}