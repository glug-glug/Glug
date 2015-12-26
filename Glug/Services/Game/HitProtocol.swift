//
//  HitProtocol.swift
//  Glug
//
//  Created by piton on 26.12.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

protocol HitProtocol {
    func hit()
}

extension HitProtocol {
    func hit() {
        (self as? CKUnit)?.remove()
    }
}
