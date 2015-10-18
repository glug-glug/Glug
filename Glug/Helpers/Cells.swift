
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
    
    var level: Level? {
        didSet {
            clear()
            guard let level = level else {
                return
            }
            nameLabel.text = level.name
            numberLabel.text = String(level.number)
        }
    }
    
    func clear() {
        nameLabel.text = nil
        numberLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let bg = Constants.Colors.background
        backgroundColor = bg
        contentView.backgroundColor = bg
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = Constants.Colors.levelCellSelected
        selectedBackgroundView = bgColorView
    }
}