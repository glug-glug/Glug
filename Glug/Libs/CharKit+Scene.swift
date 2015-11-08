//
//  CharKit+Scene.swift
//  Glug
//
//  Created by piton on 27.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

extension CharKit {
    
    class Scene: Updateble {
        
        let size: Size
        var background: String = CharKit.bg 
        
        private var units: [Unit] = []
        
        var countUnits: Int {
            return units.count ?? 0
        }
        
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
            units.remove(unit)
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
            return Rect(origin: Point.zeroPoint, size: self.size).points
        }()
        
        typealias UnitChunk = (unit: Unit, char: Unit.Chunk?)
        
        subscript(point: Point) -> [UnitChunk] {
            return units.flatMap {
                if let ch = $0[point] {
                    return ($0, ch)
                } else {
                    return nil
                }
            }
        }
        
        subscript(point: Point) -> UnitChunk? {
            return (self[point] as [UnitChunk]).reduce(nil) {
                return $1.unit > $0?.unit ? $1 : $0
            }
        }
        
        subscript(point: Point) -> Unit.Chunk? {
            return (self[point] as UnitChunk?)?.char
        }
        
        subscript(point: Point) -> Unit? {
            return (self[point] as UnitChunk?)?.unit
        }
        
        subscript(position: Point, sprite: Sprite, filter: (Unit -> Bool)?) -> [Unit] {
            return units.flatMap {
                guard filter?($0) ?? true else {
                    return nil
                }
                return $0.intersects(position, sprite: sprite) ? $0 : nil
            }
        }

        subscript(unit: Unit, filter: (Unit -> Bool)?) -> [Unit] {
            return self[unit.position, unit.sprite, {
                return $0 !== unit && (filter?($0) ?? true)
            }]
        }

        subscript(unit: Unit) -> [Unit] {
            return self[unit, nil]
        }
        
        var presentation: String {
            
            var res = ""
            var y = 0
            
            for point in points {
                if point.y > y {
                    res += "\n"
                }
                y = point.y
                if let ch: Unit.Chunk = self[point] {
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
}

//extension CKScene {
//    
//}
