//
//  CreditsController.swift
//  Glug
//
//  Created by piton on 18.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import UIKit
import CoreMotion

class CreditsController: BaseMenuController {
    
    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self.view)
        animator.addBehavior(self.gravity)
        animator.addBehavior(self.collision)
        animator.addBehavior(self.elasticity)
        return animator
    }()
    
    private lazy var gravity: UIGravityBehavior = {
        return UIGravityBehavior(items: self.items)
    }()
    
    private lazy var collision: UICollisionBehavior = {
        let collision = UICollisionBehavior(items: self.items)
        collision.translatesReferenceBoundsIntoBoundary = true
        return collision
    }()
    
    private lazy var elasticity: UIDynamicItemBehavior = {
        let elasticity = UIDynamicItemBehavior(items: self.items)
        elasticity.elasticity = 0.4
        return elasticity
    }()
    
    private lazy var motionManager: CMMotionManager = {
        let mm = CMMotionManager()
        typealias Q = NSOperationQueue
        mm.startDeviceMotionUpdatesToQueue(Q.currentQueue() ?? Q.mainQueue()) { motion, _ in
            guard let m = motion else {
                return
            }
            Q.mainQueue().addOperationWithBlock {
                self.gravity.gravityDirection = CGVectorMake(CGFloat(m.gravity.x), CGFloat(-m.gravity.y))
            }
        }
        return mm
    }()
    
    private lazy var items: [UIDynamicItem] = {
        return self.credits.map {
            return CreditView.create(self.view, credit: $0)
        }
    }()
    
    private lazy var service = CreditsService()
    
    private var credits: [Credit] {
        return service.credits
    }
    
    override func customize() {
        super.customize()

        _ = animator
        _ = motionManager
        view.bringSubviewToFront(controlPanel)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
}