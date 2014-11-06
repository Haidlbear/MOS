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
    @IBOutlet weak var tfPAR: UITextField!

    
    @IBAction func btnMale(sender: AnyObject) {
        btnMaleOutlet.setImage(imgMaleEnabled, forState: UIControlState.Normal)
        btnFemaleOutlet.setImage(imgFemaleDisabled, forState: UIControlState.Normal)
        app.male = true
    }
    @IBAction func btnFemale(sender: AnyObject) {
        btnFemaleOutlet.setImage(imgFemaleEnabled, forState: UIControlState.Normal)
        btnMaleOutlet.setImage(imgMaleDisabled, forState: UIControlState.Normal)
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
        tfPAR.delegate = self
        
        //initilize textfileds with data from app-model
        tfName.text = app.name
        tfAge.text = String(app.age)
        tfHeight.text = String(app.height)
        tfWeight.text = String(app.weight)
        tfPAR.text = String(app.par)
        
        
    }
    

    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        self.initAppModel()
        textField.resignFirstResponder()
        return true;
    }

    
   @IBAction func hideKeyboard (sender:AnyObject) {
        self.initAppModel()
        self.view .endEditing(true)
    }
    
    func initAppModel(){
        
        if(self.checkIfValidNumber(tfAge.text)){
            if(tfAge.text.toInt()>5 && tfAge.text.toInt()<100){
                app.age = tfAge.text.toInt()!
            }
        }
        if(self.checkIfValidNumber(tfWeight.text).0){ //.0 return type is bool
            if(tfWeight.text.toInt()>30 && tfWeight.text.toInt()<300){
                app.weight = tfWeight.text.toInt()!
            }        }
        if(self.checkIfValidNumber(tfHeight.text)){
            if(tfHeight.text.toInt()>60 && tfHeight.text.toInt()<250){
                app.height = tfHeight.text.toInt()!
            }
        }
        
        if(self.checkIfValidNumber(tfPAR.text)){
            if(tfPAR.text.toInt()>=0 && tfPAR.text.toInt()<8){
                app.par = tfPAR.text.toInt()!
            }
        }
        
        app.name = tfName.text
        
        if(checkIfAllDataAvailable())
        {
            var genderMultiplicator = 0
            
            if(app.male){
                genderMultiplicator = 1
            }
            
            var vo1 = 0.133 * Double(app.age) - 0.005 * Double(pow(Double(app.age),2))
            var vo2 = (11.403 * Double(genderMultiplicator)) + (1.463 * Double(app.par))
            app.vo2Max = vo1 + vo2 + (9.17 * (Double(app.height))/100) - (0.254 * Double(app.weight)) + 34.143
        }
        
        appDelegate.saveAllData()
        //remove keyboard after pressing enter button

    }
    
    
    func checkIfValidNumber(number: String) -> Bool
    {
        var num = number.toInt()
        if num != nil {
            //valid number
            return true
        }
        else {
            //is valid number
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
    
    func checkIfAllDataAvailable () ->Bool
    {
        
        if !(app.age==0 && app.height==0 && app.weight==0)
        {
            return true
        }
        return false
    }
    

}