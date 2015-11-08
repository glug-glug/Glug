//
//  CharKit+View.swift
//  Glug
//
//  Created by piton on 27.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import UIKit

extension CharKit {
    
    class View: UITextView, Updateble {
        
        var ti = 0.04 // ~24 ps
        
        private lazy var updater: Updater = {
            return Updater(ti: self.ti) { [weak self] time in
                self?.update(time)
            }
        }()
        
        var scene: CKScene?
        
        var presentation: String {
            return scene?.presentation ?? ""
        }
        
        func update(time: UpdateTime) {
            scene?.update(time)
            render()
        }
        
        func play() {
            updater.play()
        }
        
        func stop() {
            updater.stop()
        }
        
        func render() {
            text = presentation
        }
        
        deinit {
            stop()
        }        
    }
}


