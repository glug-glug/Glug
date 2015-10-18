//
//  LevelsController.swift
//  Glug
//
//  Created by Александр on 23.08.15.
//  Copyright (c) 2015 iOSDevCourse. All rights reserved.
//

import UIKit

class LevelsController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var levelsService = LevelsService()
    
    var levels: Levels {
        return levelsService.levels
    }
    
    subscript (idx: Int) -> Level? {
        return 0..<levels.count ~= idx ? levels[idx] : nil
    }
    
    private lazy var controlPanel: ControlPanel = {
        var preferenses = ControlPanel.Preferences()
        let onSelect: (ControlPanel.Options) -> () = { [weak self] option in
            if option == .Home {
                self?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        let view = ControlPanel(preferences: preferenses, onSelect: onSelect)
        self.view.addSubview(view)
        return view
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bringSubviewToFront(controlPanel)
        customize()
    }
    
    func customize() {
        view.backgroundColor = Constants.Colors.background
        tableView.backgroundColor = Constants.Colors.background
    }
}
extension LevelsController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return true
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
}

extension LevelsController: UITableViewDelegate {
    
}
