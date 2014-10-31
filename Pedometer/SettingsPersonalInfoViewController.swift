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
    
    var app = AppSingletonClass.sharedSingletonInstance()
    var tag:Int = 0
    let imgMaleEnabled = UIImage(named: "ic_male_enabled") as UIImage
    let imgMaleDisabled = UIImage(named: "ic_male_disabled") as UIImage

    let imgFemaleEnabled = UIImage(named: "ic_woman_enabled") as UIImage
    let imgFemaleDisabled = UIImage(named: "ic_woman_disabled") as UIImage

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
        tfWeight.text = String(app.weight)
        
    }
    

    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        app.name = tfName.text
        app.age = tfAge.text.toInt()!
        app.height = tfHeight.text.toInt()!
        app.weight = tfWeight.text.toInt()!
        textField.resignFirstResponder()

        return true;
    }
    
}