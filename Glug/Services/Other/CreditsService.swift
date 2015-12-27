//
//  CreditsService.swift
//  Glug
//
//  Created by piton on 26.12.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

typealias Credit = (name: String?, image: String?, url: String?, group: Bool?)

class CreditsService {
    
    let file = ("credits", "plist")
    
    lazy var credits: [Credit] = {
       
        guard let url = NSBundle.mainBundle().URLForResource(self.file.0, withExtension: self.file.1) else {
            return []
        }
        
        let res: [Credit] = NSArray(contentsOfURL: url)?.flatMap {
            
            guard let d = $0 as? [String: AnyObject] else {
                return nil
            }
            
            var credit: Credit
            credit.name  <~ d["Name"]
            credit.image <~ d["Image"]
            credit.url   <~ d["Url"]
            credit.group <~ d["Group"]
            
            return credit
            
            } ?? []
        
        return res.reverse()
    }()
}



