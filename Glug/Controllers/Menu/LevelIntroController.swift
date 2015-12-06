//
//  LevelIntroController.swift
//  Glug
//
//  Created by piton on 06.12.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import UIKit

class LevelIntroController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    
    var onFinish: (() -> ())?
    
    var value: Int = 3 {
        didSet {
            countdownLabel.text = "\(value)"
        }
    }
    
    var level: Level? {
        didSet {
            if !isViewLoaded() {
                return
            }
            titleLabel.text = level?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        level = { self.level }()
        value = { self.value }()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        countdown()
    }

    private func countdown() {
        if value < 1 {
            end()
            return
        }
        
        let delta = Int64(1 * Double(NSEC_PER_SEC))
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue()) {
            self.value--
            self.countdown()
        }    
    }
    
    private func end() {
        removeFromParentViewController()
        view.removeFromSuperview()
        onFinish?()
    }
    
    static func show(parent: UIViewController, level: Level, onFinish: (() -> ())?) {
        
        let vc = UIStoryboard.create(.LevelIntro) as! LevelIntroController
        vc.level = level
        vc.onFinish = onFinish
        
        parent.addChildViewController(vc)
        let v = vc.view
        parent.view.addSubview(v)
        
        Constraint.fill(v)
    }
    
    deinit {
        print("!!!!----")
    }
}

