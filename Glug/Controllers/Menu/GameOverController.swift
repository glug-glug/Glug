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
    
    var onAction: ((GameActions) -> ())?
    
    var result: GameResult? {
        didSet {
            if !isViewLoaded() {
                return
            }
            titleLabel.text = result?.name
            actionButton.setTitle(result?.action.name, forState: .Normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        result = { self.result }()
    }
    
    @IBAction func action(sender: AnyObject) {
        removeFromParentViewController()
//        view.removeFromSuperview()
        onAction?(.Next)
    }
    
    static func show(parent: UIViewController, result: GameResult, onAction: ((GameActions) -> ())?) {
       
        let vc = UIStoryboard.create(.GameOver) as! GameOverController
        vc.result = result
        vc.onAction = onAction
        parent.addChildViewController(vc)
        
        let v = vc.view
        parent.view.addSubview(v)
        
        Constraint.fill(v)
    }
    
    deinit {
        print("!!!!")
    }
}

