//
//  CharKit+Sprite.swift
//  Glug
//
//  Created by piton on 27.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

extension CharKit {
    
    class Sprite {
        
        var size: Size
        var data: [Character?]
        
        init(size: Size, data: [Character?]) {
            self.size = size
            self.data = data
        }

        convenience init(_ ch: Character) {
            self.init(size: Size(1, 1), data: [ch])
        }
        
        convenience init(_ array: [String], bg: Character = CharKit.spriteBg) {
            
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
        
        convenience init(_ string: String, separator: String = "\n", bg: Character = CharKit.spriteBg) {
            self.init(string.componentsSeparatedByString(separator), bg: bg)
        }
        
        func copy() -> CKSprite {
            return CKSprite(size: size, data: data)
        }
        
        static var emptySprite: Sprite {
            return Sprite(size: Size(0, 0), data: [])
        }
        
        subscript(point: Point) -> Character? {
            let r = Rect(origin: Point.zeroPoint, size: size)
            if point.inRect(r) {
                return data[size.width * point.y + point.x]
            }
            return nil
        }
    }
}