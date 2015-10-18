//
//  CharKit+ControlPanel.swift
//  Glug
//
//  Created by piton on 13.09.15.
//  Copyright (c) 2015 anukhov. All rights reserved.
//

import UIKit

extension CharKit {
    
    class ControlPanel: UIView {
        
        enum Options {
            case Home, Play
        }
        
        var onSelect: ((Options) -> ())?
        var onExpand: (() -> ())?
        
        enum States {
            case Collapsed
            case Normal
            mutating func invert() {
                self = self == .Collapsed ? .Normal : .Collapsed
            }
        }
        
        var preferences = Preferences()
        
        var size: CGSize {
            return state == .Collapsed ? preferences.collapsedSize : preferences.normalSize
        }
        
        var rect: CGRect {
            let size = self.size
            return CGRectMake(0, 0, size.width, size.height)
        }
        
        var state: States = .Collapsed {
            didSet {
                UIView.animateWithDuration(0.4) {
                    self.bounds = self.rect
                    self.layoutSubviews()
                }
            }
        }

        private func addImageSubview(image: UIImage?) -> UIImageView {
            let view = UIImageView(image: image)
            view.userInteractionEnabled = true
            self.addSubview(view)
            return view
        }
        
        lazy var homeImageView: UIImageView = {
            return self.addImageSubview(self.preferences.images.home)
        }()

        lazy var playImageView: UIImageView = {
            return self.addImageSubview(self.preferences.images.play)
            }()
        
        init(preferences: Preferences? = nil, onSelect: ((Options) -> ())? = nil, onExpand: (() -> ())? = nil) {
           
            self.preferences = preferences ?? Preferences()
            let pref = self.preferences
            state = pref.initState
            let size = state == .Collapsed ? pref.collapsedSize : pref.normalSize
            super.init(frame: CGRectMake(0, 0, size.width, size.height))
            
            center = pref.center
            clipsToBounds = true
            alpha = pref.alpha
            backgroundColor = pref.colors.background
            layer.cornerRadius = pref.radius
            layer.borderColor = pref.colors.border.CGColor
            layer.borderWidth = pref.borderWidth

            self.onSelect = onSelect
            self.onExpand = onExpand
            
            configureConstraints()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        private func configureConstraints() {
            
            let _ = [homeImageView, playImageView].map {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }

            Constraint.add(self, "H:[v(32)]-15-|", ["v": homeImageView])
            Constraint.add(self, "H:[v(32)]-15-|", ["v": playImageView])
            Constraint.add(self, "V:[hv(32)]-20-[mv(32)]-15-|", ["hv": homeImageView, "mv": playImageView])
        }
        
        override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
            
            let onSelect: (Options) -> () = { option in
                if option == .Home {
                    self.hidden = true
                }
                self.onSelect?(option)
            }
            
            if state == .Normal {
                
                if let view = touches.first?.view {
                    switch view {
                    case homeImageView:
                        onSelect(.Home)
                    case playImageView:
                        onSelect(.Play)
                    default:
                        return
                    }
                }
            } else {
                onExpand?()
            }
            
            state.invert()
        }
    }
}

extension CharKit.ControlPanel {
    
    struct Preferences {
        var normalSize: CGSize = CGSizeMake(120, 240)
        var collapsedSize: CGSize = CGSizeMake(110, 110)
        var center = CGPoint(x: 0, y: CharKit.statusBarHidden ? 0 : 10)
        var radius: CGFloat = 50
        var alpha: CGFloat = 0.7
        var borderWidth: CGFloat = 2
        var initState = States.Collapsed
        var colors = (
            background: UIColor(white: 0.5, alpha: 0.5),
            border: UIColor(hex: 0xcccccc)
        )
        var images: (home: UIImage?, restart: UIImage?, play: UIImage?) = (nil, nil, nil)
    }
}