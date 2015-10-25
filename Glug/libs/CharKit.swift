//
//  CharKitLight.swift
//  Glug
//
//  Created by piton on 23.08.15.
//  Copyright (c) 2015 anukhov. All rights reserved.
//

import UIKit

typealias CKScene = CharKit.Scene
typealias CKView = CharKit.View
typealias CKPoint = CharKit.Point
typealias CKRect = CharKit.Rect
typealias CKSize = CharKit.Size
typealias CKUnit = CharKit.Unit
typealias CKSprite = CharKit.Sprite

protocol Updateble: class {
    func update(time: UpdateTime)
}

func +=(inout point: CKPoint, direction: Directions) {
    point = point + direction
}

func +(var point: CKPoint, direction: Directions) -> CKPoint {
    
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

func +=(inout str: String, char: Character) {
    str += String(char)
}

func -(p1: CKPoint, p2: CKPoint) -> CKPoint {
    return CKPoint(p1.x - p2.x, p1.y - p2.y)
}

func +(p1: CKPoint, p2: CKPoint) -> CKPoint {
    return CKPoint(p1.x + p2.x, p1.y + p2.y)
}

func /(s: CKSize, rhs: Int) -> CKSize {
    return CKSize(s.width / rhs, s.height / rhs)
}

func /(p: CKPoint, rhs: Int) -> CKPoint {
    return CKPoint(p.x / rhs, p.y / rhs)
}

func >(u1: CKUnit, u2: CKUnit) -> Bool {
    return u1.zPosition > u2.zPosition
}

extension CGRect {
    init(rect: CKRect) {
        self = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height)
    }
}

class CharKit {
    
    struct Point {
        
        var x: Int
        var y: Int
        
        static let zeroPoint = Point(0, 0)
        
        init(_ x: Int, _ y: Int) {
            self.x = x
            self.y = y
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
        func inRect(rect: Rect) -> Bool {
            return CGRect(rect: rect).contains(CGRect(rect: self))
        }
    }
    
    struct Sprite {
        
        var size: Size
        var data: [Character?]
        
        init(size: Size, data: [Character?]) {
            self.size = size
            self.data = data
        }
        
        init(character ch: Character) {
            self.init(size: Size(1, 1), data: [ch])
        }
        
        init(_ array: [String], backgroundChar bg: Character = "◻️") {
            
            let (w, h) = (
                array.sort({ $0.count > $1.count }).first?.count ?? 0,
                array.count
            )
            
            var data: [Character?] = []
            
            for str in array {
                for ch in str.characters {
                    if case bg = ch {
                        data += [nil]
                    } else {
                        data += [ch as Character?]
                    }
                }
                for _ in 0..<(w - str.count) {
                    data += [nil]
                }
            }
            
            self.init(size: CKSize(w, h), data: data)
        }
        
        init(_ string: String, separator: String = "\n", backgroundChar bg: Character = "◻️") {
            self.init(string.componentsSeparatedByString(separator), backgroundChar: bg)
        }
        
        static var emptySprite: Sprite {
            return Sprite(size: Size(0, 0), data: [])
        }
    }
    
    class Unit: Updateble {
        
        typealias Chunk = Character
        
        weak var scene: Scene!
        
        var position: Point
        var zPosition: Int
        var sprite: Sprite
        var direction: Directions?
        var speed: Int = 0

        // TODO: tmp
        var canOut: Bool = false
        
        
        var center: Point {
            get {
                return position + sprite.size.point / 2
            }
            set (p) {
                position = p - (sprite.size / 2).point
            }
        }
        
        var rect: Rect {
            return Rect(origin: position, size: sprite.size)
        }
        
        // TODO: !!
        var outOfScene: Bool {
            return position.inRect(scene.rect)
        }
        
//        // TOD: test, tmp
        var nexOutOfScene: Bool {
            guard let d = direction else {
                return false
            }
            return !(position + d).inRect(scene.rect)
        }
        
        var nextPosition: Point {
            if let dir = direction where speed > 0 {
                let pos = position + dir
                
                if canOut {
                    return pos
                }
                
                for p in [pos, Point(position.x, pos.y), Point(pos.x, position.y)] {
                    if Rect(origin: p, size: sprite.size).inRect(scene.rect) {

// TODO: check collisions !!

//                        let r = Rect(origin: p, size: sprite.size)
//                        for v in (scene[r] as [Unit]?) ?? [] {
//                            if v !== self {
//                                return position
//                            }
//                        }
                        
                        return p
                    }
                }
            }
            return position
        }

        init(sprite: Sprite? = nil,
            position: Point? = nil,
            center: Point? = nil,
            speed: Int = 0,
            direction: Directions? = nil,
            zPosition: Int = 0) {
                
            self.sprite = sprite ?? Sprite.emptySprite
            self.position = position ?? Point.zeroPoint
            self.zPosition = zPosition
            self.speed = speed
            
            if let center = center {
                self.center = center
            }
            
            let _ = { self.direction = direction }()
        }
        
        subscript(point: Point) -> Character? {
            if point.inRect(rect) {
                let p = point - position
                return sprite.data[sprite.size.width * p.y + p.x]
            }
            return nil
        }
        
        func remove() {
            scene.removeUnit(self)
        }
        
        func update(time: UpdateTime) {
            if !(speed > 0 && time % speed == 0) {
                return
            }
            position = nextPosition
        }
    }
    
    class Scene: Updateble {
        
        let size: Size
        var background: String = "⎢" // TODO: from map ? "Ш" "⎢" !!!
        
        private var units: [Unit] = []
        
        weak var delegate: Updateble?
        
        func addUnit(unit: Unit) {
            unit.scene = self
            units.append(unit)
        }
        
        func addUnits(units: [Unit]) {
            for u in units {
                addUnit(u)
            }
        }
        
        func removeUnit(unit: Unit) {
            for (i, u) in units.enumerate() {
                if u === unit {
                    units.removeAtIndex(i)
                    return
                }
            }
        }
        
        var rect: Rect {
            return Rect(origin: Point.zeroPoint, size: size)
        }
        
        init(width: Int, height: Int) {
            size = Size(width, height)
        }
        
        convenience init(size: Size) {
            self.init(width: size.width, height: size.height)
        }
        
        lazy var points: [Point] = {
            var res = [Point]()
            for y in 0..<self.size.height {
                for x in 0..<self.size.width {
                    res.append(Point(x, y))
                }
            }
            return res
            }()
        
        typealias UnitChunk = (unit: Unit, char: Unit.Chunk?)
        
        subscript(point: Point) -> [UnitChunk] {
            var res = [UnitChunk]()
            for unit in units {
                if let ch = unit[point] {
                    res.append((unit, ch))
                }
            }
            return res
        }
        
        subscript(point: Point) -> UnitChunk? {
            var res: UnitChunk?
            for val in self[point] as [UnitChunk] {
                if res == nil || val.unit > res!.unit {
                    res = val
                }
            }
            return res
        }
        
        subscript(point: Point) -> Unit.Chunk? {
            return (self[point] as UnitChunk?)?.char
        }
        
        subscript(point: Point) -> Unit? {
            return (self[point] as UnitChunk?)?.unit
        }
        
        // TODO:
        subscript(rect: Rect) -> [Unit]? {
            var res = [Unit]()
            for unit in units {
                if unit.rect.inRect(rect) {
                    res.append(unit)
                }
            }
            return res.isEmpty ? nil : res
        }

        var presentation: String {
            
            var res = ""
            
            var prevY = 0
            
            for point in points {
                
                if point.y > prevY {
                    res += "\n"
                }
                
                prevY = point.y
                
                if let ch = self[point] as Character? {
                    res += ch
                } else {
                    res += background
                }
            }
            
            return res
        }
        
        func update(time: UpdateTime) {
            for unit in units {
                unit.update(time)
            }
            delegate?.update(time)
        }
    }
    
    class View: UITextView, Updateble {
        
        private let ti = 0.08
        
        private lazy var updater: Updater = {
            return Updater(ti: self.ti) { [weak self] time in
                self?.update(time)
            }
            }()
        
        var scene: CKScene? {
            didSet {
                updater.reset()
            }
        }
        
        private var timer: NSTimer? {
            willSet{
                stop()
            }
        }
        
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







