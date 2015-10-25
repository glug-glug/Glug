//
//  Directions.swift
//  Glug
//
//  Created by piton on 05.09.15.
//  Copyright (c) 2015 anukhov. All rights reserved.
//

import Foundation

public enum Directions: String {
    case Right      = "➡️"
    case RightDown  = "↘️"
    case Down       = "⬇️"
    case DownLeft   = "↙️"
    case Left       = "⬅️"
    case LeftUp     = "↖️"
    case Up         = "⬆️"
    case UpRight    = "↗️"
    
    static let stop = "⏹"
}

extension Directions {
    
    mutating func invert() {
        switch self {
        case .Left:      self = .Right
        case .Right:     self = .Left
        case .Up:        self = .Down
        case .Down:      self = .Up
        case .RightDown: self = LeftUp
        case .DownLeft:  self = UpRight
        case .LeftUp:    self = RightDown
        case .UpRight:   self = DownLeft
        }
    }
    
    func split() -> (horizontal: Directions?, vertical: Directions?) {
        typealias D = Directions
        switch self {
        case .Right:        return (D.Right, nil)
        case .RightDown:    return (D.Right, D.Down)
        case .Down:         return (nil, D.Down)
        case .DownLeft:     return (D.Left, D.Down)
        case .Left:         return (D.Left, nil)
        case .LeftUp:       return (D.Left, D.Up)
        case .Up:           return (nil, D.Up)
        case .UpRight:      return (D.Right, D.Up)
        }
    }
    
    var horizontal: Directions? {
        return split().horizontal
    }
    
    var vertical: Directions? {
        return split().vertical
    }
}


extension Directions {
    init?(_ raw: Int) {
        switch raw {
        case 0: self = Right
        case 1: self = RightDown
        case 2: self = Down
        case 3: self = DownLeft
        case 4: self = Left
        case 5: self = LeftUp
        case 6: self = Up
        case 7: self = UpRight
        default:
            return nil
        }
    }
}
