//
//  LevelManager.swift
//  Glug
//
//  Created by Александр on 11.08.15.
//  Copyright (c) 2015 iOSDevCourse. All rights reserved.
//

import Foundation

class LevelManager {
    
    static let sharedManager = LevelManager()
    
    private var plistArray: NSMutableArray!
    private var path: (String)!
    
    init() {
        path = getPlistPath()
    }
    
    func createLevels() {
        
        let fileManager = NSFileManager.defaultManager()
        
        if !fileManager.fileExistsAtPath(path) {
            
            if let bundlePath = NSBundle.mainBundle().pathForResource("Levels", ofType: "plist") {
                
                fileManager.copyItemAtPath(bundlePath, toPath: path, error: nil)
                
                plistArray = NSMutableArray(contentsOfFile: bundlePath)
                
                createLevel(count: 10)
            }
        }
        
        if plistArray == nil {
            plistArray = NSMutableArray(contentsOfFile: path)
        }
    }
    
    func getPlistArray() -> NSMutableArray {
        return plistArray
    }
    
    func completeLevel(index: Int) {
        
        if index >= 0 && index <= plistArray.count - 1 {
    
            plistArray.objectAtIndex(index).setObject(true, forKey: "isComplete")
            plistArray.writeToFile(path, atomically: false)
            
        }
    }
    
    func notCompleteLevel(index: Int) {
        
        if index >= 0 && index <= plistArray.count - 1 {
            
            plistArray.objectAtIndex(index).setObject(false, forKey: "isComplete")
            plistArray.writeToFile(path, atomically: false)
            
        }
    }
    
    //MARK: - Helpers Methods
    
    private func createLevel(#count: Int) {
        
        for i in 1...count {
            
            let name = "Уровень " + String(i)
            let levelData = ["Number" : i, "Name" : name, "isComplete" : false]
            
            plistArray.addObject(levelData)
        }
        
        plistArray.writeToFile(path, atomically: false)
    }
    
    private func getPlistPath() -> (String) {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("Levels.plist")
        
        return path
    }
    
}