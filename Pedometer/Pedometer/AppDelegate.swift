//
//  AppDelegate.swift
//  Pedometer
//
//  Created by Eduard Berbecaru on 09/10/14.
//  Copyright (c) 2014 FH-Hagenberg. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var app = AppSingletonClass.sharedSingletonInstance()
    var userDefaults = NSUserDefaults.standardUserDefaults()
    func  applicationDidFinishLaunching(application: UIApplication) {
        getAllData()
    }
    
    func  applicationDidBecomeActive(application: UIApplication) {
        getAllData()

    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        getAllData()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
       saveAllData()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        getAllData()
    }

   

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveAllData()
    }
    
    func saveAllData(){
        userDefaults.setValue(app.name, forKey: "name")
        userDefaults.setValue(app.age, forKey: "age")
        userDefaults.setValue(app.height, forKey: "height")
        userDefaults.setValue(app.weight, forKey: "weight")
        userDefaults.setValue(app.par, forKey: "par")
        userDefaults.setBool(app.male, forKey: "boolMale")
        userDefaults.synchronize() // don't forget this!!!!
    }
    
    func getAllData(){
        
        if(userDefaults.valueForKey("name") != nil && userDefaults.valueForKey("par") != nil){
            app.name = userDefaults.valueForKey("name") as String
            app.age = userDefaults.valueForKey("age") as Int
            app.height = userDefaults.valueForKey("height") as Int
            app.weight = userDefaults.valueForKey("weight") as Int
            app.par = userDefaults.valueForKey("par") as Int
            app.male = userDefaults.valueForKey("boolMale") as Bool
        }
        
       

    }


}

