//
//  ParentViewController.swift
//  Glug
//
//  Created by Александр on 11.08.15.
//  Copyright (c) 2015 iOSDevCourse. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 29 / 255, green: 34 / 255, blue: 46 / 255, alpha: 1)
    }
    
    //MARK: - Actions
    
    @IBAction func backToMainMenu(sender: UIStoryboardSegue) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Helpers Methods
    
    func addAttributeButton(button: UIButton, text: String, size: CGFloat, color: UIColor) {
        
        let attribute = [NSFontAttributeName : UIFont(name: "Minecraft", size: size)!]
        
        let attributeString = NSAttributedString(string: text, attributes: attribute)
        
        button.setAttributedTitle(attributeString, forState: UIControlState.Normal)
        button.titleLabel?.textColor = color
    }
    
    func addAttributeLabel(label: UILabel, text: String, firstCharColor: UIColor, otherCharsColor: UIColor, size: CGFloat) {
        
        let firstChar = text.substringToIndex(advance(text.startIndex, 1))
        let otherChars = text.substringFromIndex(advance(text.startIndex, 1))
        
        let attr1 = [NSForegroundColorAttributeName : firstCharColor]
        let attr2 = [NSForegroundColorAttributeName : otherCharsColor]
        
        var attrString1 = NSMutableAttributedString(string: firstChar, attributes: attr1)
        var attrString2 = NSMutableAttributedString(string: otherChars, attributes: attr2)
        
        attrString1.appendAttributedString(attrString2)
        
        label.attributedText = attrString1
        label.font = UIFont(name: "Minecraft", size: size)
    }
    
}
