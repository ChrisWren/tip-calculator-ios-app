//
//  ViewController.swift
//  tips
//
//  Created by Chris Wren on 4/27/16.
//  Copyright © 2016 Chris Wren. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var tipAndSplitContainerView: UIView!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billFieldContainerView: UIView!

    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var personNumPicker: UIPickerView!
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale.currentLocale()
        tipLabel.text = formatter.stringFromNumber(0)
        totalLabel.text = formatter.stringFromNumber(0)
            
        let billFieldPlaceholder = NSLocale.currentLocale().objectForKey(NSLocaleCurrencySymbol) as? String
        
        self.billField!.placeholder = billFieldPlaceholder
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let isDarkMode = defaults.boolForKey("darker_theme")
        var color = UIColor.blackColor()
        if isDarkMode {
            color = UIColor.whiteColor()
        }
        
        let str = NSAttributedString(string: billFieldPlaceholder!, attributes: [NSForegroundColorAttributeName:color])
        billField.attributedPlaceholder = str
        
        let defaultTipPercentIndex = defaults.integerForKey("default_tip_percentage_index")
        if let cachedBillAmount = defaults.objectForKey("bill_amount") as? Double {
            if (cachedBillAmount != 0) {
                let formatter = NSNumberFormatter()
                formatter.numberStyle = .DecimalStyle
                formatter.locale = NSLocale.currentLocale()
                billField.text = formatter.stringFromNumber(defaults.doubleForKey("bill_amount"))
            }
        }
        personNumPicker.delegate = self
        personNumPicker.dataSource = self
        pickerData = ["1","2","3","4","5","6","7","8","9","10"]
        tipControl.selectedSegmentIndex = defaultTipPercentIndex
        updateTotal()
        billField.becomeFirstResponder()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    @IBAction func onTapSendBillSplit(sender: AnyObject) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let splitAmount = defaults.doubleForKey("total_bill_amount") / Double(pickerData[(personNumPicker.selectedRowInComponent(0))])!
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale.currentLocale()
            
            let activityViewController = UIActivityViewController(activityItems: ["Hey, your part of the split bill is \(formatter.stringFromNumber(splitAmount)!)"], applicationActivities: nil)
            presentViewController(activityViewController, animated: true, completion: {})
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(animated: Bool) {

    }
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        updateTotal()
        let defaults = NSUserDefaults.standardUserDefaults()
        let isDarkMode = defaults.boolForKey("darker_theme")
        var color = UIColor.blackColor()
        if isDarkMode {
            color = UIColor.whiteColor()
        }
        billField.textColor = color
    }
    
    func updateTotal() {
        let tipPercentages = [0.18, 0.2, 0.22]
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.locale = NSLocale.currentLocale()
        
        
        let billAmount = Double(formatter.numberFromString(String(billField.text!)) ?? 0.0)
        let tip = billAmount * tipPercentage
        let total = billAmount + tip
        formatter.numberStyle = .CurrencyStyle
        tipLabel.text = formatter.stringFromNumber(tip)
        totalLabel.text = formatter.stringFromNumber(total)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setDouble(billAmount, forKey: "bill_amount")
        defaults.setDouble(total, forKey: "total_bill_amount")
        defaults.synchronize()
        
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let defaults = NSUserDefaults.standardUserDefaults()
        let isDarkMode = defaults.boolForKey("darker_theme")
        var color = UIColor.blackColor()
        if isDarkMode {
            color = UIColor.whiteColor()
        }
        
        return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName:color])
    }
    override func viewWillAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let isDarkMode = defaults.boolForKey("darker_theme")
        switchTheme(self.view, isDarkMode: isDarkMode)
        switchTheme(self.billFieldContainerView, isDarkMode: isDarkMode)
        var color = UIColor.blackColor()
        if isDarkMode {
            color = UIColor.whiteColor()
        }
        billField.textColor = color
    }
}

