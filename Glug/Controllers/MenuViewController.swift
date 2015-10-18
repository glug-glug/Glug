//
//  MenuViewController.swift
//  Glug
//
//  Created by Александр on 06.08.15.
//  Copyright (c) 2015 iOSDevCourse. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuTitleLabel: UILabel!
    @IBOutlet weak var tapToPlayButton: UIButton!
    @IBOutlet weak var creditsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAttributeLabelAndButton()        
        view.backgroundColor = Constants.Colors.background
    }

    //MARK: - Helpers Methods
    
    func font(size: CGFloat) -> UIFont {
        return UIFont(name: "Minecraft", size: size) ?? UIFont.systemFontOfSize(size)
    }
    
    private func addAttributeLabelAndButton() {

        addAttributeLabel(menuTitleLabel, text: "Glug", firstCharColor: .yellowColor(), otherCharsColor: .whiteColor(), size: 64)
        
        addAttributeButton(tapToPlayButton, text: "Play", size: 20, color: .whiteColor())
        addAttributeButton(creditsButton, text: "Credits", size: 20, color: .whiteColor())
    }
    
    func addAttributeButton(button: UIButton, text: String, size: CGFloat, color: UIColor) {

        let attribute = [NSFontAttributeName: font(size)]
        let attributeString = NSAttributedString(string: text, attributes: attribute)
        
        button.setAttributedTitle(attributeString, forState: UIControlState.Normal)
        button.titleLabel?.textColor = color
    }
    
    func addAttributeLabel(label: UILabel, text: String, firstCharColor: UIColor, otherCharsColor: UIColor, size: CGFloat) {
        
        let firstChar = text.substringToIndex(text.startIndex.advancedBy(1))
        let otherChars = text.substringFromIndex(text.startIndex.advancedBy(1))
        
        let attr1 = [NSForegroundColorAttributeName : firstCharColor]
        let attr2 = [NSForegroundColorAttributeName : otherCharsColor]
        
        let attrString1 = NSMutableAttributedString(string: firstChar, attributes: attr1)
        let attrString2 = NSMutableAttributedString(string: otherChars, attributes: attr2)
        
        attrString1.appendAttributedString(attrString2)
        
        label.attributedText = attrString1
        label.font = font(size)
    }
}
