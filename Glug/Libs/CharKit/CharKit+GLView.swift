//
//  CharKit+GLView.swift
//  Glug
//
//  Created by piton on 22.11.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import UIKit
import SpriteKit

extension CharKit {

    class GLView: SKView, Updateble {
        
        var ckScene: CKScene?
        
        var glScene: GLScene? {
            return scene as? GLScene
        }
        
        var color: UIColor? {
            get {
                return glScene?.backgroundColor
            }
            set {
                if let color = newValue {
                    glScene?.backgroundColor = color
                }
            }
        }
        
        convenience init(size: CKSize) {
            self.init()
            
            showsFPS = true
            showsNodeCount = true
            ignoresSiblingOrder = true
            // allowsTransparency = true
            
            frameInterval = 2
            
            userInteractionEnabled = false
            multipleTouchEnabled = true
            
            let scene = GLScene(size: size)
            scene.updateDelegate = self

            presentScene(scene)
        }
        
        var pause: Bool = true {
            didSet {
                paused = pause
            }
        }
        
        func play() {
            pause = false
        }
        
        func stop() {
            pause = true
            
//            let act = SKAction.sequence([
//                SKAction.waitForDuration(0.0001),
//                SKAction.performSelector("pauseTimer", onTarget: self)
//                ])
//
//            glScene?.runAction(act, withKey: "pauseTimer")
        }
        
//        func pauseTimer() {
//            paused = true
//        }
        
        func update(time: UpdateTime) {
            if pause {
                paused = true
                return
            }
            ckScene?.update(time)
            glScene?.presentation = ckScene?.presentationData
        }
    }
    
    class GLScene: SKScene {
        
        weak var updateDelegate: Updateble?
        
        var ckSize: CKSize!
        
        convenience init(size: CKSize) {
            self.init()

            scaleMode = .ResizeFill
            ckSize = size
        }
        
        var presentation: [String]? {
            didSet {
                for (i, val) in (presentation ?? []).enumerate() {
                    self[i]?.text = val
                }
            }
        }

        subscript (idx: Int) -> SKLabelNode? {
            return 0..<labels.count ~= idx ? labels[idx] : nil
        }
        
        lazy var labels: [SKLabelNode] = {
            return self.textNode.children.flatMap {
                return $0 as? SKLabelNode
            }
        }()
        
        lazy var textNode: SKNode = {
            
            var node = SKNode()
            
            let fSize = CharKit.Optimal.fontSize
            let xShift = CharKit.Optimal.xShift
            let yShift: CGFloat = 4
            let h = fSize - 5
            
            func label() -> SKLabelNode {
                let l = SKLabelNode(fontNamed: "Helvetica-Light")
                if !kDebugRender {
                    l.fontColor = UIColor(hex: 0xffffff, alpha: 0.000001)
                }
                l.fontSize = fSize
                l.horizontalAlignmentMode = .Left
                return l
            }
            
            let height = self.ckSize.height
            
            for i in 0..<height {
                let l = label()
                let y = l.position.y + (CGFloat(height) - CGFloat(i) - 1) * h
                l.position = CGPointMake(l.position.x + xShift, y + yShift);
                node.addChild(l)
            }
            
            self.addChild(node)
            
            return node
        }()
        
        override func didMoveToView(view: SKView) {
            _ = textNode
        }
        
        var time: UpdateTime = 0 {
            didSet {
                if time > 100 {
                    time = 0
                }
            }
        }
        
        override func update(currentTime: CFTimeInterval) {
            updateDelegate?.update(++time)
        }

//        override func didFinishUpdate() {
//            updateDelegate?.update(++time)
//        }
    }
}

