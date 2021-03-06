//
//  SettingsViewController.swift
//  Pedometer
//
//  Created by Dan Neatu on 16.10.14.
//  Copyright (c) 2014 FH-Hagenberg. All rights reserved.
//

import Foundation
import UIKit


class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        
    }
    
    @IBOutlet weak var labelSettingsCell: UILabel!
    var settings: [String] = ["SET PERSONAL INFO"," SET YOUR GOAL"]
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 98.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        if(indexPath.row == 0){
            cell = tableView.dequeueReusableCellWithIdentifier("personalInfoCell", forIndexPath: indexPath) as UITableViewCell
            (cell.viewWithTag(1) as UILabel).text = settings[0]
        }
        
        if(indexPath.row == 1){
            cell = tableView.dequeueReusableCellWithIdentifier("goalCell", forIndexPath: indexPath) as UITableViewCell
            (cell.viewWithTag(1) as UILabel).text = settings[1]
        
        }

        //change color of the selected Cell
        var selectedUIView:UIView = UIView()
        selectedUIView.backgroundColor = UIColor(netHex: 0x4F525B)
        cell.selectedBackgroundView = selectedUIView
        
        return cell
    }
    
    //change statusbar color to white
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
