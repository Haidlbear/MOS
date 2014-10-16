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
    
    var values: [Double]=[Double]()
    var steps: Int=0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        motionManager.accelerometerUpdateInterval = 0.01
        motionManager.gyroUpdateInterval = 0.01
        
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler: {
            accelerationData, error in
            
            var acclX: Double = accelerationData.acceleration.x
            var acclY: Double = accelerationData.acceleration.y
            var acclZ: Double = accelerationData.acceleration.z
            
            var absoluteValue = self.getAbsoluteValue(acclX, acclY: acclY, acclZ: acclZ)
            
            self.values.append(absoluteValue)
            
            
            var index = self.values.count - 1
            if( index > -1 && absoluteValue > 1.5 && self.values[index] > 1 && self.values[index] > self.values[index-1]) {
                self.steps = self.steps + 1
            }
            
            //self.tv.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            self.tv.dataSource = self
            self.tv.reloadData()
        })
        
        
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
//        if(indexPath.row == 1){
//            
//            cell = tableView.dequeueReusableCellWithIdentifier("heartCell", forIndexPath: indexPath) as UITableViewCell
//        }
            
            
        else{
            cell = tableView.dequeueReusableCellWithIdentifier("doubleCell", forIndexPath: indexPath) as UITableViewCell
            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200.0
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
}
