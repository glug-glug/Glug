//
//  Helper.swift
//  Glug
//
//  Created by piton on 18.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import UIKit

func log(text: String?) {
    print(text ?? "")
}

infix operator <! {}

func <!<T>(inout lhs: T, rhs: AnyObject?) {
    lhs = rhs as! T
}

infix operator <~ {}

func <~<T>(inout lhs: T, rhs: AnyObject?) {
    lhs = (rhs as? T) ?? lhs
}

func uniq<S: SequenceType, E: Hashable where E == S.Generator.Element>(source: S) -> [E] {
    var seen: [E: Bool] = [:]
    return source.filter { v -> Bool in
        return seen.updateValue(true, forKey: v) == nil
    }
}

var defaults: NSUserDefaults {
    return NSUserDefaults.standardUserDefaults()
}

class Node<T> {
    
    typealias N = Node<T>
    
    weak var previus: N? = nil
    weak var next: N? = nil
    var value: T

    init(value: T, previus: N? = nil, next: N? = nil) {
        self.value = value
        self.previus = previus
    }
}

class List<T: Equatable> {
    
    typealias N = Node<T>
    
    var items: [N] = []
    
    var first: N? {
        return items.first
    }

    var last: N? {
        return items.last
    }
    
    func add(item: T) {        
        let node = Node(value: item, previus: last)
        last?.next = node
        items.append(node)
    }
    
    var count: Int {
        return items.count
    }
    
    subscript (idx: Int) -> N? {
        return 0..<items.count ~= idx ? items[idx] : nil
    }

    subscript (idx: Int) -> T? {
        return (self[idx] as N?)?.value
    }
    
    subscript (item: T) -> N? {
        return items.filter({ $0.value == item }).first
    }
}

infix operator <^> {}

func <^> (lhs: CKUnit, rhs: Directions?) {
    lhs.direction = rhs
}

extension String {
    
    var count: Int {
        return characters.count
    }
    
// TODO:
//    mutating func replace(string: String, atIdex: Int) {        
//        let start = startIndex.advancedBy(atIdex, limit: self.endIndex)
//        let end = startIndex.advancedBy(atIdex + 1, limit: self.endIndex)
//        let range = start ..< end
//        self.replaceRange(range, with: string)
//    }
//    
//    // TODO: limits
//    subscript(idx: Int) -> String {
//        get {
//            return String(self[startIndex.advancedBy(idx, limit: self.endIndex)])
//        }
//        set {
//            self.replace(newValue, atIdex: idx)
//        }
//    }
}

extension Int {

    static func random(lower: Int = 0, _ upper: Int = 100) -> Int {
        if lower > upper {
            return 0
        }
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    static func random(lower: Int = 0, _ upper: Int = 100, count: Int, exclude: [Int] = []) -> [Int] {
        
        var tmp = [Int]()
        let attempts = 100
        
        func r() -> Int {
            var (r, cnt) = (lower, 0)
            repeat {
                r = Int.random(lower, upper)
            } while (tmp.contains(r) || exclude.contains(r)) && cnt++ < attempts
            tmp.append(r)
            return r
        }

        return (0..<count).map { _ in
            r()
        }
    }
}

func * (lhs: String, rhs: Int) -> String {
    var s = ""
    for _ in 0..<rhs {
        s += lhs
    }
    return s
}

func * (lhs: Character, rhs: Int) -> String {
    return String(lhs) * rhs
}

extension Array {
    
     mutating func remove<T: Equatable>(element: T) {
        var j = 0
        for (i, el) in enumerate() {
            guard el as? T == element else {
                continue
            }
            removeAtIndex(i + j--)
        }
    }

    mutating func add(element: Element) {
        self.append(element)
    }
}

enum Device {
    
    enum Orientation {
        case H
        case V
    }

    case iPadPro(Orientation)
    case iPad(Orientation)
    case iPhone4(Orientation)
    case iPhone5(Orientation)
    case iPhone6(Orientation)
    case iPhone6p(Orientation)
    
    init() {
        
        let r = UIScreen.mainScreen().bounds.size

        let o: Orientation = r.width > r.height ? .H : .V
        let h = max(r.width, r.height)
        
        switch h {
        case _ where h <= 480:
            self = iPhone4(o)
        case _ where h <= 568:
            self = iPhone5(o)
        case _ where h <= 667:
            self = iPhone6(o)
        case _ where h <= 736:
            self = iPhone6p(o)
        case _ where h <= 1024:
            self = iPad(o)
        default:
            self = iPadPro(o)
        }
    }
}




