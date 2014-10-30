//
//  SettingsViewController.swift
//  Pedometer
//
//  Created by Dan Neatu on 16.10.14.
//  Copyright (c) 2014 FH-Hagenberg. All rights reserved.
//

import Foundation
import UIKit


class SettingsViewController: UIViewController{
    
    @IBOutlet weak var settingsTableView: UITableView!
    
 override func viewDidLoad() {
    
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
