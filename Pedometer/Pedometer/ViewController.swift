//
//  ViewController.swift
//  Pedometer
//
//  Created by Eduard Berbecaru on 09/10/14.
//  Copyright (c) 2014 FH-Hagenberg. All rights reserved.
//

import UIKit
import CoreMotion


class ViewController: UIViewController {
    
    let motionManager = CMMotionManager()
    
    var values: [Double]=[Double]()
    var steps: Int=0
    
    @IBOutlet var LabelSteps: UILabel!
    @IBOutlet var LabelX: UILabel!
    @IBOutlet var LabelY: UILabel!
    @IBOutlet var LabelZ: UILabel!
    
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
            
            self.LabelX.text = NSString(format:"%.4f", acclX)
            self.LabelY.text = NSString(format:"%.4f", acclY)
            self.LabelZ.text = NSString(format:"%.4f", acclZ)
            
            var index = self.values.count - 1
            if( index > -1 && absoluteValue > 1.5 && self.values[index] > 1 && self.values[index] > self.values[index-1]) {
                self.steps = self.steps + 1
                self.LabelSteps.text = String(self.steps)
            }
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAbsoluteValue(acclX: Double, acclY: Double, acclZ: Double) -> Double {
        return sqrt(pow(acclX,2) + pow(acclY,2) + pow(acclZ,2))
    }
    
    
}

