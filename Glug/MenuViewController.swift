//
//  MenuViewController.swift
//  Glug
//
//  Created by Александр on 06.08.15.
//  Copyright (c) 2015 iOSDevCourse. All rights reserved.
//

import UIKit

class MenuViewController: ParentViewController {
    
    @IBOutlet weak var menuTitleLabel: UILabel!
    @IBOutlet weak var tapToPlayButton: UIButton!
    @IBOutlet weak var creditsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAttributeLabelAndButton()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Helpers Methods
    
    private func addAttributeLabelAndButton() {
        
        addAttributeLabel(menuTitleLabel, text: "Glug", firstCharColor: .yellowColor(), otherCharsColor: .whiteColor(), size: 64)
        
        addAttributeButton(tapToPlayButton, text: "Play", size: 20, color: .whiteColor())
        addAttributeButton(creditsButton, text: "Credits", size: 20, color: .whiteColor())
        
    }
    
    

}
