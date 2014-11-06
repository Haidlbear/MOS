//
//  TableViewController.swift
//  Pedometer
//
//  Created by Eduard Berbecaru on 16/10/14.
//  Copyright (c) 2014 FH-Hagenberg. All rights reserved.
//

import UIKit
import CoreMotion
import Foundation

import CoreBluetooth
import QuartzCore

extension Int {
    func format(f: String) -> String {
        return NSString(format: "%\(f)d", self)
    }
}

let scosche_deviceInfoServiceUUID = "180A"
let scosche_heartRateServiceUUID = "180D"
let scosche_measurementCharacteristicUUID = "2A37"
let scosche_bodyLocationCharacteristicUUID = "2A38"
let scosche_manufactureNameCharacteristicUUID = "2A29"

class Main: UIViewController , UITableViewDataSource, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager: CBCentralManager!
    var scoschePeripheral: CBPeripheral!
    
    @IBOutlet var tv: UITableView!
    
    @IBOutlet var go: UIButton!
    @IBOutlet var stop: UIButton!
    @IBOutlet var reset: UIButton!
    
    let motionManager = CMMotionManager()
    
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
    var lastTimeStamp: NSTimeInterval = NSDate.timeIntervalSinceReferenceDate()
    
    var timer: NSTimer!
    var timerSeconds = 0 //89223 // 24:47:03
    var seconds = 0
    var minutes = 0
    var houres = 0
    let timeFormat = "02"
    var timerTimeStamp = NSDate.timeIntervalSinceReferenceDate()
    var lastTimerTimeStamp = NSDate.timeIntervalSinceReferenceDate()
    
    var app = AppSingletonClass.sharedSingletonInstance()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        motionManager.accelerometerUpdateInterval = 0.01
        
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
                                if(self.timeStamp - self.lastTimeStamp > 0.2){
                                    self.app.steps++
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
        
        tv.dataSource = self
        
        
        
        seconds = timerSeconds%60
        minutes = (timerSeconds/60)%60
        houres = timerSeconds/3600
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    @IBAction func go(sender: UIButton) {
        go.hidden = true
        stop.hidden = false
        reset.hidden = false
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "time", userInfo: nil, repeats: true)
    }
    @IBAction func stop(sender: UIButton) {
        if stop.titleLabel?.text == "GO"{
            stop.setTitle("STOP", forState: UIControlState.Normal)
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "time", userInfo: nil, repeats: true)
        }
        else{
            stop.setTitle("GO", forState: UIControlState.Normal)
            timer.invalidate()
            timer = nil
        }
    }
    @IBAction func reset(sender: UIButton) {
        stop.setTitle("STOP", forState: UIControlState.Normal)
        if(timer != nil){
            timer.invalidate()
        }
        timer = nil
        go.hidden = false
        stop.hidden = true
        reset.hidden = true
        timerSeconds = 0
        seconds = 0
        minutes = 0
        houres = 0
        tv.reloadData()
    }
    
    func time(){
        timerSeconds++
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
        if app.vo2Max > 0{
            getKcal();
        }
        doHeartBeat(++app.bpm)
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
        var cell:UITableViewCell!
        
        if(indexPath.row == 0){
            cell = tableView.dequeueReusableCellWithIdentifier("stepCell", forIndexPath: indexPath) as UITableViewCell
            (cell.viewWithTag(1) as UILabel).text = String (app.steps)
            (cell.viewWithTag(2) as UIProgressView).progress = Float(Double(app.stepsGoal) / Double(app.steps) / 100.0)
            (cell.viewWithTag(3) as UILabel).text = String (app.stepsGoal / app.steps)
            (cell.viewWithTag(4) as UILabel).text = String (app.stepsGoal)
        }
        
        if(indexPath.row == 1){
            cell = tableView.dequeueReusableCellWithIdentifier("heartCell", forIndexPath: indexPath) as UITableViewCell
            (cell.viewWithTag(1) as UILabel).text = String (app.bpm)
            (cell.viewWithTag(2) as UILabel).text = String (app.bpmMax)
            (cell.viewWithTag(3) as UILabel).text = String (app.bpmMin)
            (cell.viewWithTag(4) as UILabel).text = String (format: "%.0f", app.bpmAverage)
            (cell.viewWithTag(5) as UILabel).text = String (seconds)
            //(cell.viewWithTag(6) as UILabel).text = String (manufacturer)
        }
        
        if(indexPath.row == 2){
            cell = tableView.dequeueReusableCellWithIdentifier("doubleCell", forIndexPath: indexPath) as UITableViewCell
            (cell.viewWithTag(1) as UILabel).text = String (format: "%.1f", Double (self.app.steps) * 0.7)
            (cell.viewWithTag(2) as UILabel).text = String (format: "%.0f", self.app.kcal)
        }
        
        if(indexPath.row == 3){
            cell = tableView.dequeueReusableCellWithIdentifier("timeCell", forIndexPath: indexPath) as UITableViewCell
            (cell.viewWithTag(1) as UILabel).text = String (houres.format("02")) + ":" + String (minutes.format("02")) + ":" + String(seconds.format("02"))
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
    
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        peripheral.delegate = self
        peripheral .discoverServices(nil)
        
        println("Connected: " + (peripheral.state == CBPeripheralState.Connected ? "YES" : "NO"))
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        if peripheral != nil && peripheral.name != nil{
            println(peripheral.name)
            if peripheral.name == "RHYTHM+"{
                centralManager.stopScan()
                scoschePeripheral = peripheral
                peripheral.delegate = self
                centralManager.connectPeripheral(peripheral, options: nil)
            }
        }
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        var bluetooth = false
        if(central.state == CBCentralManagerState.PoweredOff){
            NSLog("CoreBluetooth BLE hardware is powered off")
        }
        else if(central.state == CBCentralManagerState.PoweredOn){
            NSLog("CoreBluetooth BLE hardware is powered on and ready")
            centralManager.scanForPeripheralsWithServices(nil, options: nil)
        }
        else if(central.state == CBCentralManagerState.Unauthorized){
            NSLog("CoreBluetooth BLE state is unauthorized")
        }
        else if(central.state == CBCentralManagerState.Unknown){
            NSLog("CoreBluetooth BLE state is unknown")
        }
        else if(central.state == CBCentralManagerState.Unsupported){
            NSLog("CoreBluetooth BLE hardware is unsupported on this platform")
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        for service in peripheral.services {
            println("Discovered service: " + (service as CBService).UUID.UUIDString)
            peripheral.discoverCharacteristics(nil, forService: service as CBService)
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        if service.UUID.UUIDString == scosche_heartRateServiceUUID{
            for aCharactaristic in service.characteristics {
                if (aCharactaristic as CBCharacteristic).UUID.UUIDString == scosche_measurementCharacteristicUUID {
                    scoschePeripheral.setNotifyValue(true, forCharacteristic: aCharactaristic as CBCharacteristic)
                    println("Found heart rate measurement characteristic")
                }
            }
        }
        
        if service.UUID.UUIDString == scosche_deviceInfoServiceUUID{
            for aCharactaristic in service.characteristics {
                if (aCharactaristic as CBCharacteristic).UUID.UUIDString == scosche_manufactureNameCharacteristicUUID{
                    scoschePeripheral.setNotifyValue(true, forCharacteristic: aCharactaristic as CBCharacteristic)
                    println("Found a device manufacturer name characteristic")
                }
            }
        }
        
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if characteristic.UUID.UUIDString == scosche_measurementCharacteristicUUID{
            getHeartBPMData(characteristic, error: error)
        }
    }
    
    func getHeartBPMData(characteristic: CBCharacteristic!, error: NSError!) {
        var data:NSData = characteristic.value
        println(data)
        var reportData = [UInt8](count: data.length, repeatedValue:0)
        data.getBytes(&reportData, length:data.length)
        doHeartBeat(Int (reportData[1]))
        }
    
    func doHeartBeat(bpm: Int){
        app.bpm = bpm
        
        if bpm < app.bpmMin{
            app.bpmMin = bpm
        }
        if bpm > app.bpmMax{
            app.bpmMax = bpm
        }
        
        var bpmAmount = app.bpmAmount
        var sum = (app.bpmAverage * Double(app.bpmAmount)) + Double(bpm)
        app.bpmAmount++
        app.bpmAverage = sum / Double (app.bpmAmount)
    }
    
    func getKcal(){
        var gender = 0.0
        if app.male {
            gender = 1.0
        }
        
        var ee1 = -36.3781 + 0.271 * Double (app.age) + 0.394 * Double (app.weight)
        var ee2 = 0.404 * app.vo2Max + 0.634 * Double (app.bpm)
        var ee3 = 0.274 * Double (app.age) + 0.103 * Double (app.weight) + 0.380 * app.vo2Max + 0.450 * Double (app.bpm)
        
        app.energyExpenditure = -59.3954 + gender * (ee1 + ee2) + (1 - gender) * (ee3)
        
        app.kcal += (app.energyExpenditure/60)/4.168
    }
}
