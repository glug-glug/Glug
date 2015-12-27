//
//  AudioService.swift
//  Glug
//
//  Created by piton on 27.12.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import AVFoundation

enum SystemSounds: SystemSoundID {

    case Win  = 1026
    case Lose = 1053
    case Fire = 1104
    
    case Wrong

    var systemSoundID: SystemSoundID {
        if case Wrong = self {
            return SystemSoundID(kSystemSoundID_Vibrate)
        }
        return rawValue
    }
}

protocol AudioService {
    func play(sound: SystemSounds)
}

extension AudioService {

    func play(sound: SystemSounds) {
        AudioServicesPlaySystemSound(sound.systemSoundID)
    }
}
