//
//  LevelsService.swift
//  Glug
//
//  Created by Александр on 11.08.15.
//  Copyright (c) 2015 iOSDevCourse. All rights reserved.
//

import Foundation

class LevelsService {
    
    let kCompletedLevels = "CompletedLevels"
    let file = ("Levels", "plist")
    
    lazy var levels: List<Level> = {
        let completed = self.completed
        var list = List<Level>()        
        self.read().forEach {
            $0.isComplete = completed.contains($0.number)
            list.add($0)
        }
        return list
        }()
    
    private func read() -> [Level] {
        guard let url = NSBundle.mainBundle().URLForResource(file.0, withExtension: file.1) else {
            return []
        }
        var num = 0
        return NSArray(contentsOfURL: url)?.map {
            return Level(dictionary: $0 as! Dictionary, number: ++num, service: self)
            } ?? []
    }

    private var completed: [Int] {
        return defaults.objectForKey(kCompletedLevels) as? [Int] ?? []
    }
    
    func complete(level: Level) {
        level.isComplete = true
        let obj = uniq(completed + [level.number])
        defaults.setObject(obj, forKey: kCompletedLevels)
    }
        
    func locked(level: Node<Level>?) -> Bool {
        guard let level = level else {
            return true
        }
        return !(level.previus?.value.isComplete ?? true)
    }
    
    func locked(level: Level) -> Bool {
        return locked(levels[level])
    }
    
    func next(level: Level) -> Level? {
        return levels[level]?.next?.value
    }
}

extension LevelsService {
    
    func reset() {
        defaults.setObject(nil, forKey: kCompletedLevels)
        levels.items.forEach {
            $0.value.isComplete = false
        }
    }
}


