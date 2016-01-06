//
//  GCService.swift
//  Glug
//
//  Created by piton on 27.12.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import UIKit
import GameKit

class GCService: NSObject {
    
    let leaderboardIdentifier = "Glug"
    
    var player: GKLocalPlayer {
        return GKLocalPlayer.localPlayer()
    }
    
    func present(vc: UIViewController?) {
        guard let vc = vc else {
            return
        }
        UIApplication.rootViewController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    func auth() {
        player.authenticateHandler = { print($0.1); self.present($0.0) }
    }
    
    func showLeader() {
        let vc = GKGameCenterViewController()
        vc.gameCenterDelegate = self
        vc.viewState = .Leaderboards
        vc.leaderboardIdentifier = leaderboardIdentifier
        present(vc)
    }
}

extension GCService: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}

//class ViewController: UIViewController, GKGameCenterControllerDelegate {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        authenticateLocalPlayer()
//    }
    
    
//    func saveHighScore(score: Int) {
//        if GKLocalPlayer.localPlayer().authenticated {
//            var scoreReporter = GKScore(leaderboardIdentifier: leaderboardIdentifier)
//            scoreReporter.value = Int64(score)
//            var scoreArray: [GKScore] = [scoreReporter]
//            
//            GKScore.reportScores(scoreArray) { error in
//                if error != nil {
//                    //ERROR
//                }
//                else {
//                    //OK
//                }
//            }
//        }
//    }
    
//    func showLeader() {
//        var gcViewController: GKGameCenterViewController = GKGameCenterViewController()
//        gcViewController.gameCenterDelegate = self
//        
//        gcViewController.viewState = GKGameCenterViewControllerState.Leaderboards
//        gcViewController.leaderboardIdentifier = leaderboardIdentifier
//        
//        self.presentViewController(gcViewController, animated: true, completion: nil)
//    }
//    
//    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
//        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
//    }
    
    
    
//    @IBAction func saveProgressButtonPressed(sender: UIButton) {
//        
//        saveHighScore(170)//подставить реальный счет
//        
//        showLeader()//Показать таблицу
//    }
    
//}