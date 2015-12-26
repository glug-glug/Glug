//
//  CharKitLight.swift
//  Glug
//
//  Created by piton on 23.08.15.
//  Copyright (c) 2015 anukhov. All rights reserved.
//

import UIKit

// TODO:
#if DEBUG_SCENE_RENDER
let kDebugRender = false//true
#else
let kDebugRender = false
#endif

typealias CKScene = CharKit.Scene
typealias CKTextView = CharKit.TextView
typealias CKAttributedView = CharKit.AttributedView
typealias CKGLView = CharKit.GLView
typealias CKPoint = CharKit.Point
typealias CKRect = CharKit.Rect
typealias CKSize = CharKit.Size
typealias CKUnit = CharKit.Unit
typealias CKSprite = CharKit.Sprite

struct CharKit {
    static let bg = "—" //"⎢—"
    static let spriteBg: Character = "◻️"
}

protocol Updateble: class {
    func update(time: UpdateTime)
}

func += (inout point: CKPoint, direction: Directions) {
    point = point + direction
}

func + (var point: CKPoint, direction: Directions) -> CKPoint {
    
    switch direction {
    case .Right:
        point.x++
    case .RightDown:
        point.x++
        point.y++
    case .Down:
        point.y++
    case .DownLeft:
        point.y++
        point.x--
    case .Left:
        point.x--
    case .LeftUp:
        point.x--
        point.y--
    case .Up:
        point.y--
    case .UpRight:
        point.y--
        point.x++
    }
    
    return point
}

func += (inout str: String, char: Character) {
    str += String(char)
}

func - (p1: CKPoint, p2: CKPoint) -> CKPoint {
    return CKPoint(p1.x - p2.x, p1.y - p2.y)
}

func -= (inout lhs: CKPoint, rhs: CKPoint) {
    lhs = lhs - rhs
}

func + (p1: CKPoint, p2: CKPoint) -> CKPoint {
    return CKPoint(p1.x + p2.x, p1.y + p2.y)
}

func += (inout lhs: CKPoint, rhs: CKPoint) {
    lhs = lhs + rhs
}

func / (s: CKSize, rhs: Int) -> CKSize {
    return CKSize(s.width / rhs, s.height / rhs)
}

func / (p: CKPoint, rhs: Int) -> CKPoint {
    return CKPoint(p.x / rhs, p.y / rhs)
}

func > (u1: CKUnit, u2: CKUnit) -> Bool {
    return u1.zPosition > u2.zPosition
}

func > (u1: CKUnit, u2: CKUnit?) -> Bool {
    return u2 == nil ? true : u1.zPosition > u2!.zPosition
}

func == (p1: CKPoint, p2: CKPoint) -> Bool {
    return p1.x == p2.x && p1.y == p2.y
}

func != (p1: CKPoint, p2: CKPoint) -> Bool {
    return p1.x != p2.x || p1.y != p2.y
}

func == (s1: CKSize, s2: CKSize) -> Bool {
    return s1.width == s2.width && s1.height == s2.height
}

func + (s1: CKSize, s2: CKSize) -> CKSize {
    return CKSize(s1.width + s2.width, s1.height + s2.height)
}

func == (r1: CKRect, r2: CKRect) -> Bool {
    return r1.origin == r2.origin && r1.size == r2.size
}

func + (r1: CKRect, r2: CKRect) -> CKRect {
    return CKRect(origin: r1.origin + r2.origin, size: r1.size + r2.size)
}

extension CGRect {
    init(rect: CKRect) {
        self = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height)
    }
}

extension CharKit {
    
    struct Point {
        
        var x: Int
        var y: Int
        
        static let zeroPoint = Point(0, 0)

        init(_ x: Int, _ y: Int) {
            self.x = x
            self.y = y
        }

        init(_ point: CGPoint) {
            self.init(Int(point.x), Int(point.y))
        }
        
        init(_ size: Size) {
            self.init(size.width - 1, size.height - 1)
        }
        
        func inRect(rect: Rect) -> Bool {
            let (x, y) = (rect.origin.x, rect.origin.y)
            let (w, h) = (rect.size.width, rect.size.height)
            guard w > 0 && h > 0 else {
                return false
            }            
            return x...(x + w - 1) ~= self.x && y...(y + h - 1) ~= self.y
        }
    }
    
    struct Size {
        
        var width: Int
        var height: Int
        
        init(_ width: Int, _ height: Int) {
            self.width = width
            self.height = height
        }

        init(_ size: CGSize) {
            self.init(Int(size.width), Int(size.height))
        }
        
        var point: Point {
            return Point(width, height)
        }
        
        static var zeroSize: Size {
            return Size(0, 0)
        }
    }
    
    struct Rect {
        var origin: Point
        var size: Size

        init(origin: Point, size: Size) {
            self.origin = origin
            self.size = size
        }

        init(origin: CGPoint, size: CGSize) {
            self.init(origin: Point(origin), size: Size(size))
        }
        
        func inRect(rect: Rect) -> Bool {
            return CGRect(rect: rect).contains(CGRect(rect: self))
        }
        
        func intersects(rect: Rect) -> Bool {
            return CGRect(rect: rect).intersects(CGRect(rect: self))
        }
        
        func intersect(rect: Rect) -> Rect {
            let r = CGRect(rect: rect).intersect(CGRect(rect: self))
            if r.size == CGSizeZero {
                return Rect.zeroRect
            }
            return Rect(origin: r.origin, size: r.size)
        }
        
        static var zeroRect: Rect {
            return Rect(origin: Point.zeroPoint, size: Size.zeroSize)
        }
        
        var points: [Point] {
            if size == Size.zeroSize {
                return []
            }
            return (origin.y..<(size.height + origin.y)).reduce([Point]()) { r, y in
                return (origin.x..<(size.width + origin.x)).reduce(r) { r, x in
                    return r + [Point(x, y)]
                }
            }
        }
    }
}







