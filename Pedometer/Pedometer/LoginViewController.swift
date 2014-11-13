//
//  LoginViewController.swift
//  Pedometer
//
//  Created by Dan Neatu on 12.11.14.
//  Copyright (c) 2014 FH-Hagenberg. All rights reserved.
//

import UIKit
class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    var app = AppSingletonClass.sharedSingletonInstance()
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    var logedIn: String = String()
    
    var window: UIWindow?
    
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    
    @IBAction func btnLogin(sender: AnyObject) {
        
        if !(tfName.text == "" && tfPassword == "") {
            self.loginRequest(tfName.text, password: tfPassword.text)
        }else{
            println("name or password field is empty")
        }
        
    }
    
    
    override func viewDidLoad() {
        
        tfName.delegate = self
        tfPassword.delegate = self
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        self.initAppModel()
        textField.resignFirstResponder()
        textField.endEditing(true)
        return true;
    }
    
    
    @IBAction func hideKeyboard (sender:AnyObject) {
        self.initAppModel()
        self.view .endEditing(true)
    }
    
    func initAppModel(){
        app.name = tfName.text
        appDelegate.saveAllData()
    }
    
    
    func loginRequest(username: String, password: String)->Bool{
        var logedin:Bool = false
        
        var request = NSMutableURLRequest(URL: NSURL(string: "http://www.reecon.eu/pedometer/mobileLogin.php")!)
        
        var session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        
        var params = "name=\(username)&password=\(password)"
        // println(params)
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding);
        var err: NSError?
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            println("Response: \(response)")
            
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            var dataFromPHP: String = strData!
            
            if( dataFromPHP != ""){
                
                let arrayWithDataFromPHP = dataFromPHP.componentsSeparatedByString(",")
                
                println("data: \(dataFromPHP)")
                
                var id: String = arrayWithDataFromPHP[0]
                var logedIn: String = arrayWithDataFromPHP[1]
                
                //println(logedIn)
                
                dispatch_async(dispatch_get_main_queue())  {
                    if( logedIn == "yes"){
                        self.app.id = id.toInt()!
                        var mvc = self.storyboard?.instantiateViewControllerWithIdentifier("Main") as Main
                        self.navigationController?.pushViewController(mvc, animated: true)
                    }
                    
                }
            }
            
            //            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as NSDictionary
            //
            //            let jsonString = self.JSONStringify(json)
            //            println(jsonString)
            //
            
            
        })
        
        task.resume()
        
        return logedin
    }
    
    
    func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
        var options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
        if NSJSONSerialization.isValidJSONObject(value) {
            if let data = NSJSONSerialization.dataWithJSONObject(value, options: options, error: nil) {
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string
                }
            }
        }
        return ""
    }
}


