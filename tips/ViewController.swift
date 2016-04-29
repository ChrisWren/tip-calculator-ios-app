//
//  ViewController.swift
//  tips
//
//  Created by Chris Wren on 4/27/16.
//  Copyright © 2016 Chris Wren. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, MFMessageComposeViewControllerDelegate {
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
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
        
        let defaults = NSUserDefaults.standardUserDefaults()
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
    
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    // Configures and returns a MFMessageComposeViewController instance
    func configuredMessageComposeViewController(messageText :String) -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        messageComposeVC.body = messageText
        return messageComposeVC
    }
    
    // MFMessageComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
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
        let splitAmount = defaults.doubleForKey("bill_amount") / Double(pickerData[(personNumPicker.selectedRowInComponent(0))])!
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale.currentLocale()
        
        // Make sure the device can send text messages
        if (canSendText()) {
            // Obtain a configured MFMessageComposeViewController
            let messageComposeVC = configuredMessageComposeViewController("Hey, your part of the split bill is \(formatter.stringFromNumber(splitAmount)!)")
            
            // Present the configured MFMessageComposeViewController instance
            // Note that the dismissal of the VC will be handled by the messageComposer instance,
            // since it implements the appropriate delegate call-back
            presentViewController(messageComposeVC, animated: true, completion: nil)
        } else {
            // Let the user know if his/her device isn't able to send text messages
            let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
        }
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
        defaults.synchronize()
        
    }
}

