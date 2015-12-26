//
//  CharKit+Optimal.swift
//  Glug
//
//  Created by piton on 22.11.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import UIKit

extension CharKit {
    
    struct Optimal {
       
        static var sceneSize: CKSize {
            
            var res: CKSize!
            
            switch Device() {
                
            case .iPhone4(.H):  res = CKSize(18, 15)
            case .iPhone5(.H):  res = CKSize(21, 15)
            case .iPhone6(.H):  res = CKSize(22, 15)
            case .iPhone6p(.H): res = CKSize(21, 14)
            case .iPad(.H):     res = CKSize(18, 15)
            case .iPadPro(.H):  res = CKSize(18, 15)
                
            case .iPhone4(.V):  res = CKSize(12, 22)
            case .iPhone5(.V):  res = CKSize(12, 26)
            case .iPhone6(.V):  res = CKSize(12, 26)
            case .iPhone6p(.V): res = CKSize(12, 25)
            case .iPad(.V):     res = CKSize(14, 21)
            case .iPadPro(.V):  res = CKSize(14, 20)
            }
            
            return res
        }
        
        static var fontSize: CGFloat {
            
            switch Device() {
                
            case .iPhone4(.H):  return 26 
            case .iPhone5(.H):  return 26 
            case .iPhone6(.H):  return 30 
            case .iPhone6p(.H): return 34
            case .iPad(.H):     return 56
            case .iPadPro(.H):  return 74
                
            case .iPhone4(.V):  return 26 
            case .iPhone5(.V):  return 26 
            case .iPhone6(.V):  return 30
            case .iPhone6p(.V): return 34
            case .iPad(.V):     return 54
            case .iPadPro(.V):  return 72
            }
        }
    
        static var xShift: CGFloat {
            
            switch Device() {
                
            case .iPhone4(.H):  return 5  
            case .iPhone5(.H):  return 10 
            case .iPhone6(.H):  return 2
            case .iPhone6p(.H): return 10
            case .iPad(.H):     return 6
            case .iPadPro(.H):  return 15
                
            case .iPhone4(.V):  return 3 
            case .iPhone5(.V):  return 3 
            case .iPhone6(.V):  return 7
            case .iPhone6p(.V): return 2
            case .iPad(.V):     return 5
            case .iPadPro(.V):  return 7
            }
        }
    }
}

