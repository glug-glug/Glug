//
//  Helper.swift
//  Glug
//
//  Created by piton on 18.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import UIKit

infix operator <! {}

func <!<T>(inout lhs: T, rhs: AnyObject?) {
    lhs = rhs as! T
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

