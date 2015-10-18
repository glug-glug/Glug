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
    
    lazy var levels: Levels = {
        let completed = self.completed
        return self.read().map {
            $0.isComplete = completed.contains($0.number)
            return $0
        }
        }()
    
    private func read() -> Levels {
        guard let url = NSBundle.mainBundle().URLForResource(file.0, withExtension: file.1) else {
            return []
        }
        return NSArray(contentsOfURL: url)?.map {
            Level(dictionary: $0 as! Dictionary)
            } ?? []
    }

    private var completed: [Int] {
        return defaults.objectForKey(kCompletedLevels) as? [Int] ?? []
    }
    
    func complete(level: Level) {
        let obj = uniq(completed + [level.number])
        defaults.setObject(obj, forKey: kCompletedLevels)
    }
}


