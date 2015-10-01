//
//  JoystickPad.swift
//  Glug
//
//  Created by piton on 23.08.15.
//  Copyright (c) 2015 anukhov. All rights reserved.
//

import UIKit

protocol JoystickPadProtocol: class {
    var directionOnChanged: (Directions? -> ())? { get set }
    var angleOnChanged: (Float? -> ())? { get set }
    var onFire: (() -> ())? { get set }
    weak var delegate: JoystickPadDelegate? { get set }
    func play()
    func stop()
}

protocol JoystickPadDelegate: class {
    func joystickDirectionChanged(direction: Directions?)
    func joystickAngleChanged(angle: Float?)
    func joystickFired()
}

func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

extension Directions {
    
    init?(angle: Float) {
        
        let start = Float(M_PI_4 / 2)
        let step = Float(M_PI_4)
        
        switch angle {
        case 1 * start..<start + step * 1: self = .RightDown
        case 2 * start..<start + step * 2: self = .Down
        case 3 * start..<start + step * 3: self = .DownLeft
        case 4 * start..<start + step * 4: self = .Left
        case 5 * start..<start + step * 5: self = .LeftUp
        case 6 * start..<start + step * 6: self = .Up
        case 7 * start..<start + step * 7: self = .UpRight
        case 8 * start..<start + step * 8 - step / 2: self = .Right
        case 0..<start: self = .Right
        default:
            return nil
        }
    }
}

extension UIColor {
    
    static func color(hex: Int, alpha: Double = 1.0) -> UIColor {
        return UIColor(hex: hex, alpha: alpha)
    }
    
    convenience init(hex: Int, alpha: Double) {
        
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        
        self.init(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha:CGFloat(alpha))
    }
    
    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
}

// MARK: Joystick Pad

typealias JPreferences = JoystickPadPreferences

struct JoystickPadPreferences {
    static var diameter: CGFloat = 120
    static var centerDiameter: CGFloat = diameter / 3
    static var stickDiameter: CGFloat = diameter / 7
    static var borderWidth: CGFloat = 2
    static var alpha: CGFloat = 0.7
    static var colors = (
        base: UIColor(white: 0.5, alpha: 0.5),
        baseAlternative: UIColor(white: 0.4, alpha: 0.5),//UIColor(hex: 0xffffff, alpha: 0.5),
        stick: UIColor(hex: 0xeeeeee),
        border: UIColor(hex: 0xcccccc)
    )
}

class CircleView: UIView {
    
    convenience init(diameter d: CGFloat, color: UIColor) {
        var rect = CGRect()
        rect.size = CGSize(width: d, height: d)
        self.init(frame: rect)
        clipsToBounds = true
        alpha = JPreferences.alpha
        backgroundColor = color
        layer.cornerRadius = d / 2
    }
}

class StickView: CircleView { }

class JoystickView: CircleView {
    
    override func drawRect(rect: CGRect) {
        
        let borderWidth = JPreferences.borderWidth
        let borderColor = JPreferences.colors.border
        let centerDiameter = JPreferences.centerDiameter
        
        let center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidX(rect))
        let r = centerDiameter / 2
        let startAngle = 0 as CGFloat
        let endAngle = CGFloat(M_PI * 2)
        let circle = UIBezierPath(arcCenter: center, radius: r, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        circle.lineWidth = borderWidth
        borderColor.setStroke()
        circle.stroke()
        
        layer.borderColor = borderColor.CGColor
        layer.borderWidth = borderWidth
        
        drawSections(center)
    }
    
    func drawSections(center: CGPoint) {
        
        let lineWidth = (JPreferences.diameter - JPreferences.centerDiameter - JPreferences.borderWidth)
        let radius = JPreferences.diameter / 2
        let r = radius
        let baseAlternative = JPreferences.colors.baseAlternative
        
        var angle = CGFloat(M_PI_4 / 2)
        
        for i in 0..<8 {
            
            let startAngle = angle
            let endAngle = startAngle + CGFloat(M_PI_4)
            angle = endAngle
            
            if i % 2 == 0  {
                continue
            }
            
            let circle = UIBezierPath(arcCenter: center, radius: r, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            circle.lineWidth = lineWidth
            
            let color = baseAlternative
            
            color.setStroke()
            circle.stroke()
        }
    }
}

class JoystickPad: UIView, JoystickPadProtocol {
    
    var directionOnChanged: (Directions? -> ())?
    var angleOnChanged: (Float? -> ())?
    var onFire: (() -> ())?
    weak var delegate: JoystickPadDelegate?

    var direction: Directions? {
        didSet {
            if direction != oldValue {
                directionOnChanged?(direction)
                delegate?.joystickDirectionChanged(direction)
            }
        }
    }
    
    var angle: Float? {
        didSet {
            if angle != oldValue {
                angleOnChanged?(angle)
                delegate?.joystickAngleChanged(angle)
            }
        }
    }
    
    func fire() {
        onFire?()
        delegate?.joystickFired()
    }
    
    private var playActive: Bool = false {
        didSet {
            if !playActive {
                active = false
            }
        }
    }
    
    func play() {
        playActive = true
    }
    
    func stop() {
        playActive = false
    }
    
    private var moveTouch: UITouch?
    
    var baseDiameter: CGFloat {
        return JPreferences.diameter
    }
    
    var centerDiameter: CGFloat {
        return JPreferences.centerDiameter
    }
    
    var stickDiameter: CGFloat {
        return JPreferences.stickDiameter
    }
    
    var baseCenter: CGPoint {
        return CGPoint(x: baseDiameter / 2, y: baseDiameter / 2)
    }
    
    lazy var stick: UIView = {
        return StickView(diameter: self.stickDiameter, color: JPreferences.colors.stick)
        }()
    
    lazy var base: JoystickView = {
        let view = JoystickView(diameter: self.baseDiameter, color: JPreferences.colors.base)
        view.addSubview(self.stick)
        self.addSubview(view)
        return view
        }()
    
    func resetStick() {
        stick.center = baseCenter
    }
    
    var active = false {
        didSet {
            if active {
                base.hidden = false
                return
            }
            resetStick()
            direction = nil
            angle = nil
            moveTouch = nil
            base.hidden = true
        }
    }
}

extension JoystickPad {
    
    func firstTouch(touches: Set<UITouch>) -> UITouch {
        return touches.first!
    }
    
    func containsMoveTouch(touches: Set<UITouch>) -> Bool {
        return moveTouch != nil && touches.contains(moveTouch!)
    }
    
    func angleValue(point: CGPoint) -> Float {
        let angle = -atan2f(Float(point.x), Float(point.y)) + Float(M_PI_2)
        return angle < 0 ? angle + Float(M_PI * 2) : angle
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if !playActive {
            return
        }
        
        if active {
            fire()
            return
        }
        
        let touch = firstTouch(touches)
        moveTouch = touch
        active = true
        let point = touch.locationInView(self)
        base.center = point
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if !playActive {
            return
        }
        
        if !containsMoveTouch(touches) {
            return
        }
        
        let touch = moveTouch!
        
        let point = touch.locationInView(base)
        
        let p = point - baseCenter
        let angle = angleValue(p)
        let direction = Directions(angle: angle)
        
        let len = hypot(p.x, p.y)
        
        if direction == nil || len * 2 < centerDiameter {
            (self.direction, self.angle) = (nil, nil)
            resetStick()
            return
        }
        
        self.direction = direction
        self.angle = angle
        
        let r = baseDiameter / 2
        let shift = r - ((baseDiameter - centerDiameter) / 4)
        
        let sin = p.y / len
        let cos = p.x / len
        let y = sin * shift + r
        let x = cos * shift + r
        
        stick.center = CGPoint(x: x, y: y)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if containsMoveTouch(touches) {
            active = false
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        guard let touches = touches else {
            return
        }
        if containsMoveTouch(touches) {
            active = false
        }
    }
}
