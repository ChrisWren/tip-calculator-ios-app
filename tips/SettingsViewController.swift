//
//  SettingsViewController.swift
//  tips
//
//  Created by Chris Wren on 4/27/16.
//  Copyright © 2016 Chris Wren. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var defaultTipControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDefaultTipControlChanged(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(defaultTipControl.selectedSegmentIndex, forKey: "default_tip_percentage_index")
        defaults.synchronize()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = NSUserDefaults.standardUserDefaults()
        let defaultTipPercentIndex = defaults.integerForKey("default_tip_percentage_index")
            defaultTipControl.selectedSegmentIndex = defaultTipPercentIndex
    }
}
