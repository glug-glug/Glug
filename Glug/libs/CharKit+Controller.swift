//
//  CharKit+Controller.swift
//  Glug
//
//  Created by piton on 05.09.15.
//  Copyright (c) 2015 anukhov. All rights reserved.
//

import UIKit

typealias CKController = CharKit.Controller

typealias CKControllerProtocol = CharKitControllerProtocol

protocol CharKitControllerProtocol {
    var scene: CKScene { get set }
    var joystick: JoystickPad { get }
    func initializeScene() -> CKScene
    func stop()
    func play()
    func home()
}

extension CharKit {
    
    class GameView: CKView {
        
        var fontSize: CGFloat!
        var color: UIColor!

        lazy var attributes: [String: AnyObject] = {
            let color = self.color
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = self.fontSize - 2
            paragraphStyle.alignment = .Center
            let font = UIFont(name: "Helvetica-Light", size: self.fontSize)!
            return [
                NSKernAttributeName: -1,
                NSFontAttributeName: font,
                NSParagraphStyleAttributeName: paragraphStyle,
                NSForegroundColorAttributeName: color
            ]
            }()
        
        override func render() {
            attributedText = NSAttributedString(string: presentation, attributes: attributes)
        }
        
        convenience init(fontSize: CGFloat, color: UIColor) {
            self.init()
            self.color = color
            self.fontSize = fontSize
            // testing grid
            // backgroundColor = UIColor.whiteColor()
            backgroundColor = color
        }
    }
    
    class Controller: UIViewController, JoystickPadDelegate, CKControllerProtocol {
        
        var orientation = UIDevice.currentDevice().orientation
        
        var optimalSceneSize: Size {
            return Controller.optimalSceneSize(view.bounds)
        }
        
        var optimalFontSize: CGFloat {
            return Controller.optimalFontSize(view.bounds)
        }
        
        var color: UIColor {
            return UIColor.blackColor()
        }
        
        var scene: Scene {
            get {
                if gameView.scene == nil {
                    self.scene = initializeScene()
                }
                return gameView.scene!
            }
            set(scene) {
                gameView.scene = scene
            }
        }
        
        lazy var joystick: JoystickPad = {            
            let joystick = JoystickPad()
            joystick.delegate = self
            joystick.userInteractionEnabled = true
            joystick.multipleTouchEnabled = true
            self.view.addSubview(joystick)
            return joystick
            }()

        private lazy var gameView: GameView = {
            let view = GameView(fontSize: self.optimalFontSize, color: self.color)
            view.userInteractionEnabled = false
            view.multipleTouchEnabled = true
            self.joystick.addSubview(view)
            return view
            }()
        
        private lazy var controlPanel: ControlPanel = {
            var preferenses = ControlPanel.Preferences()
            preferenses.images = (
                UIImage(named: "home"),
                UIImage(named: "restart"),
                UIImage(named: "play")
            )
            
            let onExpand: () -> () = { [weak self] in
                print("on expanded")
                self?.stop()
            }

            let onSelect: (ControlPanel.Options) -> () = { [weak self] option in
                switch option {
                case .Home:
                    self?.home()
                    print("Home")
                case .Play:
                    print("Play")
                    self?.play()
                }
            }
            
            let view = ControlPanel(preferences: preferenses, onSelect: onSelect, onExpand: onExpand)
            self.view.addSubview(view)
            return view
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = color
            configureConstraints()
            scene = initializeScene()
            view.bringSubviewToFront(controlPanel)            
            self.play()
        }
        
        private func configureConstraints() {

            let _ = [gameView, joystick].map {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
            
            Constraint.add(view, "H:|[v]|", ["v": gameView])
            Constraint.add(view, "V:|[v]|", ["v": gameView])
            Constraint.add(view, "H:|[v]|", ["v": joystick])
            Constraint.add(view, "V:[t][v]|", ["t": topLayoutGuide, "v": joystick])
        }
        
        override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
            let mask: UIInterfaceOrientationMask = orientation.isLandscape ? .Landscape : .Portrait
            return mask
        }

        // JoystickPadDelegate
        
        func joystickDirectionChanged(direction: Directions?) { }
        
        func joystickAngleChanged(angle: Float?) { }
        
        func joystickFired() { }
        
        // CharKitControllerProtocol
        
        func initializeScene() -> CKScene {
            return CKScene(size: optimalSceneSize)
        }
        
        func stop() {
            gameView.stop()
            joystick.stop()
        }
        
        func play() {
            gameView.play()
            joystick.play()
        }
        
        func home() {
            dismissViewControllerAnimated(true, completion: nil)
        }        
    }
}

extension CKController {

    // TODO: analize device model ?
    
    static func optimalSceneSize(bounds: CGRect) -> CKSize {
        
        var res: CKSize!
        
        if bounds.width > bounds.height {
            
            switch bounds.width {
            case 568..<768:
                res = CKSize(22, 13)
            case let w where w >= 768:
                res = CKSize(19, 14)
            default:
                res = CKSize(19, 13)
            }
            
        } else {

            switch bounds.height {
            case 568..<667:
                res = CKSize(12, 21)
            case 667..<768:
                res = CKSize(13, 23)
            case let w where w >= 768:
                res = CKSize(14, 19)
            default:
                res = CKSize(12, 18)
            }
        }
        
        return CKSize(res.width - 1, res.height - 0)
    }
    
    static func optimalFontSize(bounds: CGRect) -> CGFloat {

        var res: CGFloat!
        
        if bounds.width > bounds.height {
            
            switch bounds.width {
            case 667..<736:
                res = 30
            case 736..<768:
                res = 33
            case let w where w >= 768:
                res = 55
            default:
                res = 26
            }
            
        } else {
            
            switch bounds.height {
            case 667..<736:
                res = 30
            case 736..<768:
                res = 33
            case let w where w >= 768:
                res = 54
            default:
                res = 27
            }
        }
        
        return res
    }
}

