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

func >(u1: CKUnit, u2: CKUnit) -> Bool {
    return u1.zPosition > u2.zPosition
}

extension CGRect {
    init(rect: CKRect) {
        self = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height)
    }
}

typealias UpdateTime = Int

class CharKit {
    
    struct Point {
        
        var x: Int
        var y: Int
        
        static let zeroPoint = Point(0, 0)
        
        init(_ x: Int, _ y: Int) {
            self.x = x
            self.y = y
        }
        
        func inRect(rect: Rect) -> Bool {
            let (x, y) = (rect.origin.x, rect.origin.y)
            let (w, h) = (rect.size.width, rect.size.height)
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
    }
    
    class Unit {
        
        typealias Chunk = Character
        
        weak var scene: Scene!
        
        var position: Point
        var zPosition: Int
        var sprite: Sprite
        var direction: Directions? {
            didSet {
                saveDirection(oldValue)
            }
        }
        var lastDirection: (horizontal: Directions?, vertical: Directions?)
        var speed: Int = 0
        
        var rect: Rect {
            return Rect(origin: position, size: sprite.size)
        }
        
        var outOfScene: Bool {
            return position.inRect(scene.rect)
        }
        
        var nextPosition: Point {
            if let dir = direction where speed > 0 {
                let pos = position + dir
                for p in [pos, Point(position.x, pos.y), Point(pos.x, position.y)] {
                    if Rect(origin: p, size: sprite.size).inRect(scene.rect) {
                        return p
                    }
                }
            }
            return position
        }
        
        func saveDirection(direction: Directions?) {
            if let direction = direction?.split() {
                if let direction = direction.horizontal {
                    lastDirection.horizontal = direction
                }
                if let direction = direction.vertical {
                    lastDirection.vertical = direction
                }
            }
        }
        
        init(sprite: Sprite, position: Point, speed: Int = 0, direction: Directions? = nil, zPosition: Int = 0) {
            self.sprite = sprite
            self.position = position
            self.zPosition = zPosition
            self.direction = direction
            self.speed = speed
            saveDirection(direction)
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
    
    class Scene {
        
        let size: Size
        var background: String // TODO: from map
        
        private var units: [Unit] = []
        
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
        
        init(width: Int, height: Int, background: String = "Ш") { 
            size = Size(width, height)
            self.background = background
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
        }
    }
    
    class View: UITextView {
        
        var scene: CKScene? {
            didSet {
                time = 0
            }
        }
        
        private var time: UpdateTime = 0
        
        private var timer: NSTimer? {
            willSet{
                stop()
            }
        }

        var presentation: String {
            return scene?.presentation ?? ""
        }
        
        func play() {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.08, target: self, selector: "update", userInfo: nil, repeats: true)
        }
        
        func stop() {
            timer?.invalidate()
        }
        
        func update() {
            scene?.update(time++)
            render()
        }
        
        func render() {
            text = presentation
        }
        
        deinit {
            stop()
        }
    }
}







