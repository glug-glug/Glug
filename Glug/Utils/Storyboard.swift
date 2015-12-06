//
//  Storyboard.swift
//  Glug
//
//  Created by piton on 29.11.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    enum Controllers : String {

        case GameOver = "GameOver"
        case LevelIntro = "LevelIntro"

        private var storyName: String {
            return "\(self)"
        }
        
        var story: UIStoryboard {
            return UIStoryboard(name: storyName, bundle: NSBundle.mainBundle())
        }

        var identifier: String {
            return self.rawValue
        }
    }
    
    static func create(controller: Controllers) -> UIViewController {
        return controller.story.instantiateViewControllerWithIdentifier(controller.identifier)
    }
}