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
    
    
    
    var male:Bool = true
    
    var steps = 0
    var distance = 0
    var bpm = 120
    var kcal = 0.0
    var time = 0

    
    var vo2Max = 0.0
    var energyExpenditure = 0.0
    
    
    //personal informations
    var name: String = "your name"
    var age = 0
    var height = 0
    var weight = 0
    var par = 0
    
    //goals
    var stepsGoal:Int = 0
    var distanceGoal:Int = 0
    var heartrateGoal:Int = 0
    
    class func sharedSingletonInstance() -> AppSingletonClass {
        return SingletonClassSharedInstance
    }
    

    
    
}