//
//  TableViewController.swift
//  Pedometer
//
//  Created by Eduard Berbecaru on 16/10/14.
//  Copyright (c) 2014 FH-Hagenberg. All rights reserved.
//

import UIKit
import CoreMotion

extension Int {
    func format(f: String) -> String {
        return NSString(format: "%\(f)d", self)
    }
}


class Main: UIViewController, UITableViewDataSource {
    
    @IBOutlet var tv: UITableView!
    
    @IBAction func go(sender: UIButton) {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "time", userInfo: nil, repeats: true)
    }
    @IBAction func stop(sender: UIButton) {
        self.timer.invalidate()
    }
    @IBAction func reset(sender: UIButton) {
    }
    
    let motionManager = CMMotionManager()
    
    var steps: Int=0
    var heart: Int=0
    
    var acclX: Double = 0.0
    var acclY: Double = 0.0
    var acclZ: Double = 0.0
    
    var filterArray: [Double] = [Double]()
    var filterIndex: Int = 0
    var absoluteValue: Double = 0.0
    
    var filteredValue:Double = 0.0
    var lastFilteredValue: Double = 0.0
    var stepDetected:Bool = false
    var max:Double = 0.0
    
    var array: [Double] = [Double]()
    var sumOfArray: Double = 0.0
    var average: Double = 0.0
    var oldestValue: Int = 0
    
    var timeStamp: NSTimeInterval = NSDate.timeIntervalSinceReferenceDate()
    var lastTimeStamp: NSTimeInterval = 0
    
    var timer: NSTimer!
    var seconds = 58
    var minutes = 59
    var houres = 0
    let timeFormat = "02"
    
    
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
            
            
            if(self.filterArray.count < 4){
                self.filterArray.append(self.absoluteValue)
            }else{
                if(self.filterIndex == 4){
                    var sumOfFilteredArray: Double = 0.0
                    
                    for (var index: Int = 0 ; index < 4; index++){
                        sumOfFilteredArray += self.filterArray[index]
                    }
                    self.filteredValue = sumOfFilteredArray/4
                    
                    //array with 50 actual values
                    if(self.array.count < 50){
                        self.array.append(self.filteredValue)
                        self.sumOfArray += self.filteredValue
                    } else {
                        self.sumOfArray = self.sumOfArray - self.array[self.oldestValue] + self.filteredValue
                        self.average = self.sumOfArray/50
                        
                        self.array[self.oldestValue] = self.filteredValue
                        
                        if(self.filteredValue > self.max){
                            self.max = self.filteredValue
                        }
                        
                        //just index
                        if(self.oldestValue == 49){
                            self.oldestValue = 0
                        } else{
                            self.oldestValue++
                        }
                        
                        //step occure
                        
                        if(self.filteredValue <= self.lastFilteredValue){
                            if(self.filteredValue < self.average && !self.stepDetected && self.max > 1.115){
                                self.lastTimeStamp = self.timeStamp
                                self.timeStamp = CACurrentMediaTime()
                                if(self.timeStamp - self.lastTimeStamp > 0.35){
                                    self.steps++
                                }
                                self.stepDetected = true
                                
                                self.tv.reloadData()
                            }
                            
                        }else{
                            self.stepDetected = false
                            self.max = 0.0
                        }
                        
                        self.lastFilteredValue = self.filteredValue
                    }
                    self.filterIndex = 0
                }else{
                    self.filterArray[self.filterIndex] = self.absoluteValue
                    self.filterIndex++;
                }
            }
        })
        
        self.tv.dataSource = self
        
        
        
        
    }
    
    func time(){
        if(seconds < 59){
            seconds++
        }else if(minutes < 59){
            seconds = 0
            minutes++
        }else{
            seconds = 0
            minutes = 0
            houres++
        }
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
            (cell.viewWithTag(3) as UILabel).text = String (seconds)
        }
        
        if(indexPath.row == 2){
            cell = tableView.dequeueReusableCellWithIdentifier("doubleCell", forIndexPath: indexPath) as UITableViewCell
            (cell.viewWithTag(9) as UILabel).text = String (self.steps)
        }
            
        else{
            cell = tableView.dequeueReusableCellWithIdentifier("timeCell", forIndexPath: indexPath) as UITableViewCell
            (cell.viewWithTag(5) as UILabel).text = String (houres.format("02")) + ":" + String (minutes.format("02")) + ":" + String(seconds.format("02"))
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row{
        case 0, 1:
            return 175
        case 2, 3:
            return 105
        default:
        return 200.0
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    //change statusbar color to white
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}
