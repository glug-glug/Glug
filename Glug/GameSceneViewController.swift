//
//  GameSceneViewController.swift
//  Glug
//
//  Created by Александр on 06.08.15.
//  Copyright (c) 2015 iOSDevCourse. All rights reserved.
//

import UIKit

class GameSceneViewController: ParentViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("GameSceneViewController deinit")
    }
    

    @IBAction override func backToMainMenu(sender: UIStoryboardSegue) {
        super.backToMainMenu(sender)
    }

}
