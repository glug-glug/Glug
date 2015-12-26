
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
    @IBOutlet weak var numberView: UIView!
    
    var numberLayer: CAGradientLayer?
    
    var level: Level? {
        didSet {
            clear()
            guard let level = level else {
                return
            }
            nameLabel.text = level.name
            numberLabel.text = String(level.number)
            numberLayer?.colors = mode.grColor
        }
    }
    
    func clear() {
        nameLabel.text = nil
        numberLabel.text = nil
        numberLayer?.colors = Modes.Def.grColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let bg = Constants.Colors.background
        backgroundColor = bg
        contentView.backgroundColor = bg
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(hex: 0xCCCCCC, alpha: 0.4)
        selectedBackgroundView = bgColorView
        
        numberView.layer.cornerRadius = numberView.bounds.width / 2
        numberView.backgroundColor = UIColor.clearColor()
        numberView.clipsToBounds = true
        
        let gr = CAGradientLayer()
        gr.frame = numberView.bounds
        gr.colors = mode.grColor
        gr.locations = [0, 1]
        numberView.layer.insertSublayer(gr, atIndex: 0)
        numberLayer = gr

        numberView.transform = CGAffineTransformMakeScale(2, 2)
    }
    
    enum Modes {
        case Complete
        case Locked
        case Def
        
        var color: UIColor {
            switch self {
            case .Complete: return UIColor(hex: 0xADFF2F, alpha: 0.4)
            case .Locked:   return UIColor(hex: 0xFF4500, alpha: 0.4)
            case .Def:      return UIColor(hex: 0xeeeeee, alpha: 0.4)
            }
        }
        
        var grColor: [CGColor] {
            return [color.CGColor, color.CGColor]
        }
    }
    
    var mode: Modes {
        if level?.isComplete ?? false {
            return .Complete
        } else if level?.locked ?? false {
            return .Locked
        } else {
            return .Def
        }
    }
}