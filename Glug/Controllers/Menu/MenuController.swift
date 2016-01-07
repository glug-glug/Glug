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
    @IBOutlet weak var scoreButton: UIButton!
    
    @IBOutlet var bigGlugsConstraints: [NSLayoutConstraint]!
    @IBOutlet var mediumGlugsConstraints: [NSLayoutConstraint]!
    @IBOutlet var smallGlugsConstraints: [NSLayoutConstraint]!
    @IBOutlet weak var bathyscapheConstraint: NSLayoutConstraint!

    var bathyscapheDirection: Directions = .Left
    
    lazy var updater: Updater = {
        return Updater(ti: 1) { [weak s = self] _ in
            dispatch_sync(dispatch_get_main_queue()) {
                s?.animate()
            }
        }
    }()

    lazy var gcService: GCService = {
        return GCService()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addAttributeLabelAndButton()        
        view.backgroundColor = Constants.Colors.background
        _ = gcService
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
        self.scoreButton.setTitle("\(ScoreService().score)", forState: .Normal)
    }

    @IBAction func showLeader(sender: AnyObject) {
        gcService.showLeader()
    }    
}

extension MenuController {
    
    func animate() {

        let k = 6.0
        
        animateGlugs(bigGlugsConstraints, k * 1)
        animateGlugs(mediumGlugsConstraints, k * 2)
        animateGlugs(smallGlugsConstraints, k * 5)
        
        animateBathyscaphe(bathyscapheConstraint, k * 1)
    }
    
    func animateGlugs(constraints: [NSLayoutConstraint], _ duration: Double) {

        let h = max(view.bounds.height, view.bounds.width)

        for v in constraints where v.constant < h {

            let y = v.constant

            UIView.animateWithDuration(duration,
                delay: 0,
                options: [.CurveLinear],
                animations: {
                    v.constant += y > 0 ? h : 2 * h
                    self.view.layoutIfNeeded()
                },
                completion: { _ in
                    v.constant -= 2 * h
                }
            )
        }
    }
    
    func animateBathyscaphe(constraint: NSLayoutConstraint, _ duration: Double) {
        
        let p: (CGFloat, CGFloat) = (min(view.bounds.height, view.bounds.width) / 3, 15)
        let x = constraint.constant
        let dir = bathyscapheDirection
        
        if x > p.1 && dir == .Right || x < p.0 && dir == .Left {
            
            UIView.animateWithDuration(duration,
                delay: 0,
                options: [.CurveLinear],
                animations: {
                    constraint.constant = (dir == .Left ? p.0 : p.1)
                    self.view.layoutIfNeeded()
                },
                completion: { _ in
                    self.bathyscapheDirection.invert()
                }
            )
        }
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


