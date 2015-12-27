//
//  LevelsController.swift
//  Glug
//
//  Created by Александр on 23.08.15.
//  Copyright (c) 2015 iOSDevCourse. All rights reserved.
//

import UIKit

class LevelsController: BaseMenuController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var levelsService = LevelsService()
    
    var levels: List<Level> {
        return levelsService.levels
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func customize() {
        super.customize()
        tableView.backgroundColor = Constants.Colors.background
    }
}

extension LevelsController {
    
    var selected: Node<Level>? {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return nil
        }
        return levels[indexPath.row]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as? GameController
        controller?.level = selected?.value
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        #if !DEBUG
            return true
        #endif

        if let level = selected where !levelsService.locked(level) {
            return true
        }
        return false
    }
}

extension LevelsController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {        
        let cell: LevelCell = tableView.dequeue(.Level, indexPath)
        cell.level = levels[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
