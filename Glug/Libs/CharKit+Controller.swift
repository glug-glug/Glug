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
typealias CKRender = CharKitRender
typealias CKRenderString = NSMutableAttributedString

protocol CharKitControllerProtocol: Updateble {
    var scene: CKScene { get set }
    var joystick: JoystickPad { get }
    func initializeScene() -> CKScene
    func stop()
    func play()
    func home()
}

protocol CharKitRender: class  {
    func render(value: CKRenderString) -> CKRenderString
}

extension CharKitRender {
    func render(value: CKRenderString) -> CKRenderString {
        return value
    }
}

extension CharKit {
    
    class GameView: CKView {

        var fontSize: CGFloat!

        weak var renderDelegate: CKRender?
        
        lazy var attributes: [String: AnyObject] = {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = self.fontSize - 2
            paragraphStyle.alignment = .Center
            let font = UIFont(name: "Helvetica-Light", size: self.fontSize)!
            return [
                NSKernAttributeName: -1,
                NSFontAttributeName: font,
                NSParagraphStyleAttributeName: paragraphStyle,
                NSBackgroundColorAttributeName: kDebugRender ? UIColor(hex: 0x888888) : UIColor(hex: 0xFFFFFF, alpha: 0),
                NSForegroundColorAttributeName: kDebugRender ? UIColor(hex: 0xDDDDDD) : UIColor(hex: 0xFFFFFF, alpha: 0)
            ]
            }()
        
        override func render() {
            let str = CKRenderString(string: presentation, attributes: attributes)
            attributedText = renderDelegate?.render(str) ?? str
        }
        
        convenience init(fontSize: CGFloat, color: UIColor) {
            self.init()
            
            self.fontSize = fontSize
            backgroundColor = color
            if kDebugRender {
                backgroundColor = UIColor.darkGrayColor()
            }
            //
            editable = false
            selectable = false
            userInteractionEnabled = false
            multipleTouchEnabled = true
        }
    }

    class Controller: UIViewController, JoystickPadDelegate, CKControllerProtocol, CKRender {
        
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
            view.renderDelegate = self
            self.joystick.addSubview(view)
            return view
            }()
        
        private lazy var controlPanel: ControlPanel = {
            var preferenses = ControlPanel.Preferences()
            let onExpand: () -> () = { [weak self] in
                self?.stop()
            }
            let onSelect: (ControlPanel.Options) -> () = { [weak self] option in
                switch option {
                case .Home:
                    self?.home()
                case .Play:
                    self?.play()
                }
            }            
            let view = ControlPanel(preferences: preferenses, onSelect: onSelect, onExpand: onExpand)
            self.view.addSubview(view)
            return view
        }()
        
        private lazy var statisticLabel: UILabel = {
            let view = self.view
            let label = UILabel()
            label.numberOfLines = 0
            label.font = UIFont.boldSystemFontOfSize(14)
            label.textColor = UIColor.redColor()
            label.backgroundColor = UIColor(hex: 0xffffff, alpha: 0.5)
            view.addSubview(label)
            label.bringSubviewToFront(view)
            label.translatesAutoresizingMaskIntoConstraints = false
            let views = ["l": label]
            Constraint.add(view, "H:[l(60)]|", views)
            Constraint.add(view, "V:[l(50)]|", views)
            return label
        }()
        
        var statistic: (time: NSDate?, frames: Int?)
        
        func refreshStatistic(time: UpdateTime) {
            let (time, frames) = (statistic.time ?? NSDate(), statistic.frames ?? 0)
            statistic.time = time
            statistic.frames = frames + 1
            let ti = -time.timeIntervalSinceNow
            if ti < 1 {
                return
            }
            defer {
                statistic.time = NSDate()
                statistic.frames = 0
            }
            let fps = Int(Double(frames) / ti)
            statisticLabel.text = "units: \(scene.countUnits ?? 0)\nfps: \(fps)"
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = color
            configureConstraints()
            scene = initializeScene()
            view.bringSubviewToFront(controlPanel)            
            self.play()
        }
        
        private func configureConstraints() {

            [gameView, joystick].forEach {
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
            let scene = CKScene(size: optimalSceneSize)
            scene.delegate = self
            return scene
        }
        
        func update(time: UpdateTime) {
            if kDebugRender {
                refreshStatistic(time)
            }
            
            gameView.clearsOnInsertion = true
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
        
        // Render
        
        func render(val: CKRenderString) -> CKRenderString {
            return val
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



