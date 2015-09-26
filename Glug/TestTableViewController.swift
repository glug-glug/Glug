//
//  TestTableViewController.swift
//  Glug
//
//  Created by Александр on 23.08.15.
//  Copyright (c) 2015 iOSDevCourse. All rights reserved.
//

import UIKit

class TestTableViewController: UITableViewController {
    
    var levelArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getLevelArray()
        
        tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
        
    }
    
    func getLevelArray() {
        
        levelArray.removeAllObjects()
        
        let plistArray = LevelManager.sharedManager.getPlistArray()
        
        for i in 0...plistArray.count - 1 {
            
            let level = Level(dictionary: plistArray.objectAtIndex(i) as! Dictionary)
            levelArray.addObject(level)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return levelArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! Cell
        
        let level = levelArray.objectAtIndex(indexPath.row) as! Level
        
        cell.numberLabel.text = String(level.number)
        cell.nameLabel.text = level.name
        cell.isCompleteLabel.text = level.isComplete == true ? "Complete" : "Not Complete"
        cell.isCompleteLabel.textColor = level.isComplete == true ? .greenColor() : .redColor()
        
        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            let level = levelArray.objectAtIndex(indexPath.row) as! Level
            
            if level.isComplete == true {
                LevelManager.sharedManager.levelComplete(.No, index: indexPath.row)
            } else {
                LevelManager.sharedManager.levelComplete(.Yes, index: indexPath.row)
            }
            
            getLevelArray()
            tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        
        let level = levelArray.objectAtIndex(indexPath.row) as! Level
        
        return level.isComplete == true ? "Not Complete" : "Complete"
    }

}
