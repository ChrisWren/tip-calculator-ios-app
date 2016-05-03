//
//  ThemeSwitcher.swift
//  tips
//
//  Created by Chris Wren on 5/1/16.
//  Copyright © 2016 Chris Wren. All rights reserved.
//

import Foundation
import UIKit

func switchTheme(view: UIView, isDarkMode: Bool) {
    
    var backgroundColor = UIColor.whiteColor()
    var tintColor = UIColor.blueColor()
    var textColor = UIColor.blackColor()
    
    if (isDarkMode) {
        backgroundColor = UIColor.blackColor()
        tintColor = UIColor.whiteColor()
        textColor = UIColor.whiteColor()
    }
    
    view.backgroundColor = backgroundColor
    view.tintColor = tintColor
    
    updateSubViews(view, textColor: textColor, isDarkMode: isDarkMode)
}

func updateSubViews(view: UIView, textColor: UIColor, isDarkMode: Bool) {
    for subView in view.subviews {
        if subView is UILabel {
            if let label = subView as? UILabel {
                label.textColor =  textColor
            }
        } else if subView is UITextView {
            if let textView = subView as? UITextView {
                textView.tintColor = textColor
            }
        }
    }
}
