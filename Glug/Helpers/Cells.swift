
//
//  Cells.swift
//  Glug
//
//  Created by piton on 18.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import UIKit

enum CellIdentifiers: String {
    case Level = "LevelCell"
}

class Cell: UITableViewCell { }

extension UITableView {
    
    func dequeue<T: Cell>(identifier: CellIdentifiers, _ indexPath: NSIndexPath) -> T {
        return self.dequeueReusableCellWithIdentifier(identifier.rawValue, forIndexPath: indexPath) as! T
    }
}

class LevelCell: Cell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var lockImageView: UIImageView!
    @IBOutlet weak var numberView: UIView!
    
    var level: Level? {
        didSet {
            clear()
            guard let level = level else {
                return
            }
            nameLabel.text = level.name
            numberLabel.text = String(level.number)
            lockImageView.image = level.locked ? UIImage(named: "level-locked") : nil
        }
    }
    
    func clear() {
        nameLabel.text = nil
        numberLabel.text = nil
        lockImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let bg = Constants.Colors.background
        backgroundColor = bg
        contentView.backgroundColor = bg
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(hex: 0xCCCCCC, alpha: 0.4)
        selectedBackgroundView = bgColorView
        
        customizeNumber()
    }
    
    func customizeNumber() {
        
        numberView.layer.cornerRadius = numberView.bounds.width / 2
        numberView.backgroundColor = UIColor.clearColor()
        numberView.clipsToBounds = true
        
        let gr = CAGradientLayer()
        gr.frame = numberView.bounds
        let colors = (
            UIColor(hex: 0xffffff, alpha: 0.2),
            UIColor(hex: 0xeeeeee, alpha: 0.5)
        )
        gr.colors = [colors.0.CGColor, colors.1.CGColor, colors.0.CGColor]
        gr.locations = [0, 0.5, 0.9]
        numberView.layer.insertSublayer(gr, atIndex: 0)
    }
}