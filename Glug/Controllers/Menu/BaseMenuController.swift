//
//  BaseMenuController.swift
//  Glug
//
//  Created by piton on 26.12.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import UIKit

class BaseMenuController: UIViewController, Backing {
    
    lazy var controlPanel: ControlPanel = {
        return ControlPanel.backControlPanel(self.view) { [weak self] in
            self?.back()
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bringSubviewToFront(controlPanel)
        customize()
    }
    
    func customize() {
        view.backgroundColor = Constants.Colors.background
    }
}
