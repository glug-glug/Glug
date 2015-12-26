//
//  MenuController.swift
//  Glug
//
//  Created by Александр on 06.08.15.
//  Copyright (c) 2015 iOSDevCourse. All rights reserved.
//

import UIKit

class MenuController: UIViewController {
    
    @IBOutlet weak var menuTitleLabel: UILabel!
    @IBOutlet weak var tapToPlayButton: UIButton!
    @IBOutlet weak var creditsButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var bigGlugsConstraints: [NSLayoutConstraint]!
    @IBOutlet var mediumGlugsConstraints: [NSLayoutConstraint]!
    @IBOutlet var smallGlugsConstraints: [NSLayoutConstraint]!
    @IBOutlet weak var bathyscapheConstraint: NSLayoutConstraint!

    var bathyscapheDirection: Directions?
    
    lazy var updater: Updater = {
        return Updater(ti: 0.01) { [weak self] _ in
            dispatch_sync(dispatch_get_main_queue()) {
                self?.animate()
            }
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAttributeLabelAndButton()        
        view.backgroundColor = Constants.Colors.background
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updater.play()
        refreshScore()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        updater.stop()
    }
    
    private func refreshScore() {
        scoreLabel.text = ScoreService().text
    }
}

extension MenuController {
    
    func animate() {
        animateGlugs(bigGlugsConstraints, speed: 2)
        animateGlugs(mediumGlugsConstraints, speed: 1)
        animateGlugs(smallGlugsConstraints, speed: 0.3)
        animateBathyscaphe(bathyscapheConstraint, speed: 0.2)
    }
    
    func animateGlugs(constraints: [NSLayoutConstraint], speed: CGFloat) {
        
        let h = view.bounds.height
        let delay: CGFloat = 200
        
        for v in constraints {
            var next = v.constant + speed
            if next - delay > h {
                next = 0
            }
            v.constant = next
        }
    }
    
    func animateBathyscaphe(constraint: NSLayoutConstraint, speed: CGFloat) {
        
        let p: (CGFloat, CGFloat) = (15, view.bounds.width / 3)
        let val = constraint.constant
        var dir = bathyscapheDirection ?? .Left
        if val < p.0 && dir == .Right || val > p.1 && dir == .Left {
            dir.invert()
        }
        bathyscapheDirection = dir
        constraint.constant += speed * (dir == .Left ? 1 : -1)
    }
}

extension MenuController {
    
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


