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
        
        var backgroundImage: String? {
            get {
                return glScene?.backgroundImage
            }
            set {
                glScene?.backgroundImage = newValue
            }
        }
        
        convenience init(size: CKSize) {
            self.init()
            
            if kDebugRender {
                showsFPS = true
                showsNodeCount = true
            }
            
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
        }
        
        func update(time: UpdateTime) {
            if pause {
                paused = true
                return
            }
            render(time)
        }
        
        private func render(time: UpdateTime) {
            ckScene?.update(time)
            glScene?.presentation = ckScene?.presentationData
        }
        
        func forceRender() {
            render(-1)
            paused = false
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

        private var imageNode: SKSpriteNode? {
            didSet {
                oldValue?.removeFromParent()
                if let node = imageNode {
                    node.size = frame.size
                    node.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
                    node.zPosition = -1
                    addChild(node)
                }
            }
        }
        
        var backgroundImage: String? {
            didSet {
                if backgroundImage == oldValue {
                    return
                }
                var node: SKSpriteNode?
                if let name = backgroundImage {
                    node = SKSpriteNode(imageNamed: name)
                }
                imageNode = node
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
            imageNode = { imageNode }()
        }
        
        var time: UpdateTime = 0 {
            didSet {
                if time > 1000 {
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

