//
//  App.swift
//  Pedometer
//
//  Created by Dan Neatu on 24.10.14.
//  Copyright (c) 2014 FH-Hagenberg. All rights reserved.
//

import Foundation
import CoreData

private let SingletonClassSharedInstance = AppSingletonClass()

class AppSingletonClass :NSObject {
    
    var steps = 0
    var distance = 0
    var energyExpenditure = 0
    var time = 0
    
    //personal informations
    var name: String = "your name"
    var age: Int = 0
    var height: Int = 0
    var weight: Double = 0.0
    var male:Bool = true
    var female:Bool = false
    var par: Int = 0
    
    
    //goals
    var stepsGoal:Int = 0
    var distanceGoal:Int = 0
    var heartrateGoal:Int = 0
    
    class func sharedSingletonInstance() -> AppSingletonClass {
        return SingletonClassSharedInstance
    }
    

    
    
}