
//
//  SettingsPersonalInfoViewController.swift
//  Pedometer
//
//  Created by Dan Neatu on 17.10.14.
//  Copyright (c) 2014 FH-Hagenberg. All rights reserved.
//

import Foundation
import UIKit

class SettingsPersonalInfoViewController : UITableViewController, UITextFieldDelegate{
    
    
    @IBOutlet var tv: UITableView!
    var userDefaults = NSUserDefaults.standardUserDefaults()
    var app = AppSingletonClass.sharedSingletonInstance()
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    let imgMaleEnabled = UIImage(named: "ic_male_enabled")
    let imgMaleDisabled = UIImage(named: "ic_male_disabled")
    
    let imgFemaleEnabled = UIImage(named: "ic_woman_enabled")
    let imgFemaleDisabled = UIImage(named: "ic_woman_disabled")
    
    var tfName: UITextField!
    var tfAge: UITextField!
    var tfHeight: UITextField!
    var tfWeight: UITextField!
    var tfPAR: UITextField!
    var btnMaleOutlet: UIButton!
    var btnFemaleOutlet: UIButton!
    
    
    func btnMale() {
        btnMaleOutlet.setImage(imgMaleEnabled, forState: UIControlState.Normal)
        btnFemaleOutlet.setImage(imgFemaleDisabled, forState: UIControlState.Normal)
        app.male = true
    }
    
    func btnFemale() {
        btnFemaleOutlet.setImage(imgFemaleEnabled, forState: UIControlState.Normal)
        btnMaleOutlet.setImage(imgMaleDisabled, forState: UIControlState.Normal)
        app.male = false
    }
    
    
    override func viewDidLoad() {
        //tv.dataSource = self
        
    
        
        //initilize textfileds with data from app-model
        
        
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
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        if(indexPath.row == 0){
            cell = tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as UITableViewCell
            (cell.viewWithTag(1) as UILabel).text = "Name"
            (cell.viewWithTag(2) as UITextField).text = String (app.name)
            (cell.viewWithTag(3) as UILabel).text = ""
            tfName = (cell.viewWithTag(2) as UITextField)
            tfName.delegate = self
            tfName.text = app.name
            tfName.keyboardType = UIKeyboardType.NamePhonePad
        }
        
        if(indexPath.row == 1){
            cell = tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as UITableViewCell
            (cell.viewWithTag(1) as UILabel).text = "Age"
            (cell.viewWithTag(2) as UITextField).text = String (app.age)
            (cell.viewWithTag(3) as UILabel).text = "Years"
            tfAge = (cell.viewWithTag(2) as UITextField)
            tfAge.delegate = self
            tfAge.text = String(app.age)
        }
        
        if(indexPath.row == 2){
            cell = tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as UITableViewCell
            (cell.viewWithTag(1) as UILabel).text = "Height"
            (cell.viewWithTag(2) as UITextField).text = String (app.height)
            (cell.viewWithTag(3) as UILabel).text = "cm"
            tfHeight = (cell.viewWithTag(2) as UITextField)
            tfHeight.delegate = self
            tfHeight.text = String(app.height)
        }
        
        if(indexPath.row == 3){
            cell = tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as UITableViewCell
            (cell.viewWithTag(1) as UILabel).text = "Weight"
            (cell.viewWithTag(2) as UITextField).text = String (app.weight)
            (cell.viewWithTag(3) as UILabel).text = "kg"
            tfWeight = (cell.viewWithTag(2) as UITextField)
            tfWeight.delegate = self
            tfWeight.text = String(app.weight)
        }
        
        if(indexPath.row == 4){
            cell = tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as UITableViewCell
            (cell.viewWithTag(1) as UILabel).text = "PA-R"
            (cell.viewWithTag(2) as UITextField).text = String (app.weight)
            (cell.viewWithTag(3) as UILabel).text = ""
            tfPAR = (cell.viewWithTag(2) as UITextField)
            tfPAR.delegate = self
            tfPAR.text = String(app.par)
        }
        
        if(indexPath.row == 5){
            cell = tableView.dequeueReusableCellWithIdentifier("genderCell", forIndexPath: indexPath) as UITableViewCell
            (cell.viewWithTag(1) as UILabel).text = "Gender"
            btnMaleOutlet = (cell.viewWithTag(2) as UIButton)
            btnFemaleOutlet = (cell.viewWithTag(3) as UIButton)
            if(app.male){
                btnMaleOutlet.setImage(imgMaleEnabled, forState: UIControlState.Normal)
                btnFemaleOutlet.setImage(imgFemaleDisabled, forState: UIControlState.Normal)
            }else{
                btnFemaleOutlet.setImage(imgFemaleEnabled, forState: UIControlState.Normal)
                btnMaleOutlet.setImage(imgMaleDisabled, forState: UIControlState.Normal)
            }
            
            btnMaleOutlet.addTarget(self, action: "btnMale", forControlEvents: UIControlEvents.TouchUpInside)
            btnFemaleOutlet.addTarget(self, action: "btnFemale", forControlEvents: UIControlEvents.TouchUpInside)

        }

        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    
    
}