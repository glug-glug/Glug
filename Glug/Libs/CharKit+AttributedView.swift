//
//  CharKit+AttributedView.swift
//  Glug
//
//  Created by piton on 22.11.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import UIKit

typealias CKRender = CharKitRender
typealias CKRenderString = NSMutableAttributedString

protocol CharKitRender: class  {
    func render(value: CKRenderString) -> CKRenderString
}

extension CharKitRender {
    func render(value: CKRenderString) -> CKRenderString {
        return value
    }
}

extension CharKit {
    
    class AttributedView: CKTextView {
        
        var fontSize: CGFloat!
        
        weak var renderDelegate: CKRender?
        
        lazy var attributes: [String: AnyObject] = {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = self.fontSize - 2
            paragraphStyle.alignment = .Center
            let font = UIFont(name: "Helvetica-Light", size: self.fontSize)!
            return [
                NSKernAttributeName: -1,
                NSFontAttributeName: font,
                NSParagraphStyleAttributeName: paragraphStyle,
                NSBackgroundColorAttributeName: kDebugRender ? UIColor(hex: 0x888888) : UIColor(hex: 0xFFFFFF, alpha: 0),
                NSForegroundColorAttributeName: kDebugRender ? UIColor(hex: 0xDDDDDD) : UIColor(hex: 0xFFFFFF, alpha: 0)
            ]
        }()
        
        override func render() {
            
            var text = CKRenderString(string: presentation, attributes: attributes)
            text = renderDelegate?.render(text) ?? text
            
            dispatch_sync(dispatch_get_main_queue()) {
                self.attributedText = text
            }
        }
        
        convenience init(fontSize: CGFloat, color: UIColor) {
            self.init()
            
            self.fontSize = fontSize
            backgroundColor = color
            if kDebugRender {
                backgroundColor = UIColor.darkGrayColor()
            }
            //
            editable = false
            selectable = false
            userInteractionEnabled = false
            multipleTouchEnabled = true
        }
    }
}