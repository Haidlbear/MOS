//
//  TableViewController.swift
//  Pedometer
//
//  Created by Eduard Berbecaru on 16/10/14.
//  Copyright (c) 2014 FH-Hagenberg. All rights reserved.
//

import UIKit
import CoreMotion


class Main: UIViewController, UITableViewDataSource {
    
    @IBOutlet var tv: UITableView!
    
    
    let motionManager = CMMotionManager()
    
    var steps: Int=0
    var heart: Int=0
    
    var acclX: Double = 0.0
    var acclY: Double = 0.0
    var acclZ: Double = 0.0
    
    var absoluteValue: Double = 0.0
    var lastAbsoluteValue: Double = 0.0
    var stepDetected: Bool = false
    
    var array: [Double] = [Double]()
    var sumOfArray: Double = 0.0
    var average: Double = 0.0
    var oldestValue: Int = 0
    
    var timeStamp: NSTimeInterval = NSDate.timeIntervalSinceReferenceDate()
    var lastTimeStamp: NSTimeInterval = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        motionManager.accelerometerUpdateInterval = 0.01
        motionManager.gyroUpdateInterval = 0.01
        
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler: {
            accelerationData, error in
            
            self.acclX = accelerationData.acceleration.x
            self.acclY = accelerationData.acceleration.y
            self.acclZ = accelerationData.acceleration.z
            
            self.absoluteValue = self.getAbsoluteValue(self.acclX, acclY: self.acclY, acclZ: self.acclZ)
            
            //array with 50 actual values
            if(self.array.count < 50){
                self.array.append(self.absoluteValue)
                self.sumOfArray += self.absoluteValue
            } else {
                self.sumOfArray = self.sumOfArray - self.array[self.oldestValue] + self.absoluteValue
                self.average = self.sumOfArray/50
                
                self.array[self.oldestValue] = self.absoluteValue
                
                //just index
                if(self.oldestValue == 49){
                    self.oldestValue = 0
                } else{
                    self.oldestValue++
                }
                
                //step occure
                
                if(self.absoluteValue <= self.lastAbsoluteValue){
                    if(self.absoluteValue < self.average && !self.stepDetected){
                        self.lastTimeStamp = self.timeStamp
                        self.timeStamp = CACurrentMediaTime()
                        if(self.timeStamp - self.lastTimeStamp > 0.2){
                            self.steps++
                        }
                        self.stepDetected = true

                        //self.tv.reloadData()
                        
                    }
                    
                }else{
                    self.stepDetected = false
                }
                
                self.lastAbsoluteValue = self.absoluteValue
            }
            
            
            
        })
        
        self.tv.dataSource = self
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "heartRate", userInfo: nil, repeats: true)
        
        
    }
    
    func heartRate(){
        self.heart++
        self.tv.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAbsoluteValue(acclX: Double, acclY: Double, acclZ: Double) -> Double {
        return sqrt(pow(acclX,2) + pow(acclY,2) + pow(acclZ,2))
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell
        if(indexPath.row == 0){
            cell = tableView.dequeueReusableCellWithIdentifier("stepCell", forIndexPath: indexPath) as UITableViewCell
            (cell.viewWithTag(1) as UIProgressView).progress = 0.8
            
        }
        
        if(indexPath.row == 1){
            
            cell = tableView.dequeueReusableCellWithIdentifier("heartCell", forIndexPath: indexPath) as UITableViewCell
            (cell.viewWithTag(3) as UILabel).text = String (self.heart)
        }
            
            
        else{
            cell = tableView.dequeueReusableCellWithIdentifier("doubleCell", forIndexPath: indexPath) as UITableViewCell
            (cell.viewWithTag(9) as UILabel).text = String (self.steps)
        }
        //cell.labelStepsCount.text = String(self.steps)
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200.0
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    //change statusbar color to white
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}
