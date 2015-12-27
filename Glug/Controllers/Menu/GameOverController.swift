//
//  GameOverController.swift
//  Glug
//
//  Created by piton on 29.11.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import UIKit

class GameOverController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var onAction: ((GameActions) -> ())?
    
    var actions: [GameActions] = [] {
        didSet {
            if !isViewLoaded() {
                return
            }
            guard let action = actions.first else {
                return
            }
            actionButton.setTitle(action.name, forState: .Normal)
        }
    }
    
    var result: GameResult? {
        didSet {
            if !isViewLoaded() {
                return
            }
            titleLabel.text = result?.name
            scoreLabel.text = "\(result?.score ?? 0)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        result = { self.result }()
        actions = { self.actions }()
    }
    
    @IBAction func action(sender: AnyObject) {
        guard let action = actions.first else {
            return
        }
        removeFromParentViewController()
        view.removeFromSuperview()
        onAction?(action)
    }
    
    static func show(parent: UIViewController, result: GameResult, actions: [GameActions], onAction: ((GameActions) -> ())?) {
       
        let vc = UIStoryboard.create(.GameOver) as! GameOverController
        vc.result = result
        vc.actions = actions
        vc.onAction = onAction
        parent.addChildViewController(vc)
        
        let v = vc.view
        parent.view.addSubview(v)
        
        Constraint.fill(v)
    }
}

