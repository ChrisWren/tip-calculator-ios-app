//
//  ViewController.swift
//  tips
//
//  Created by Chris Wren on 4/27/16.
//  Copyright © 2016 Chris Wren. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
        let defaults = NSUserDefaults.standardUserDefaults()
        let defaultTipPercentIndex = defaults.integerForKey("default_tip_percentage_index")
        tipControl.selectedSegmentIndex = defaultTipPercentIndex
        updateTotal()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        updateTotal()
        
    }
    
    func updateTotal() {
        let tipPercentages = [0.18, 0.2, 0.22]
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        
        
        let billAmount = NSString(string: billField.text!).doubleValue
        let tip = billAmount * tipPercentage
        let total = billAmount + tip
        
        tipLabel.text = "$\(tip)"
        totalLabel.text = "$\(total)"
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
}

