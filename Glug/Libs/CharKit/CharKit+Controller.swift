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

protocol CharKitControllerProtocol: Updateble {
    var scene: CKScene { get set }
    var joystick: JoystickPad { get }
    func initializeScene() -> CKScene
    func stop()
    func play()
    func home()
}

extension CharKit {
    
    class Controller: UIViewController, JoystickPadDelegate, CKControllerProtocol, CKRender, AppActivating {
        
        var orientation = UIDevice.currentDevice().orientation
        
        var size: CKSize {
            return CharKit.Optimal.sceneSize
        }
        
        var color: UIColor {
            return UIColor.blackColor()
        }
        
        var scene: Scene {
            get {
                if gameView.ckScene == nil {
                    self.scene = initializeScene()
                }
                return gameView.ckScene!
            }
            set(scene) {
                gameView.ckScene = scene
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

//        private lazy var gameView: AttributedView = {
//            let view = AttributedView(fontSize: self.optimalFontSize, color: self.color)
//            view.renderDelegate = self
//            self.joystick.addSubview(view)
//            return view
//            }()

        private lazy var gameView: GLView = {
            let view = GLView(size: self.size)
            view.color = self.color
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
            label.textColor = UIColor.whiteColor()
            label.backgroundColor = UIColor(hex: 0xffffff, alpha: 0.5)
            view.addSubview(label)
            label.bringSubviewToFront(view)
            label.translatesAutoresizingMaskIntoConstraints = false
            let views = ["l": label]
            Constraint.add(view, "H:[l(60)]|", views)
            Constraint.add(view, "V:[l(50)]-50-|", views)
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
            let text = "units: \(scene.countUnits ?? 0)\nfps: \(fps)"

//            dispatch_sync(dispatch_get_main_queue()) {
                self.statisticLabel.text = text
//            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = color
            configureConstraints()
            scene = initializeScene()
            view.bringSubviewToFront(controlPanel)
            startListenActivationEnevts()
        }

        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            self.play()
        }
        
        deinit {
            stopListenActivationEnevts()
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
            let scene = CKScene(size: size)
            scene.delegate = self
            return scene
        }
        
        func update(time: UpdateTime) {
            if kDebugRender {
                refreshStatistic(time)
            }
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
        
        // AppActivating
        
        func appWillResignActive() {
            controlPanel.show()
        }
        
        func appDidBecomeActive() {}
    }
}





