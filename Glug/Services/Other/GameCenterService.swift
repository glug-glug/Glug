////
////  GameCenterService.swift
////  Glug
////
////  Created by piton on 27.12.15.
////  Copyright © 2015 anukhov. All rights reserved.
////
//
//import UIKit
//import GameKit
//
//class ViewController: UIViewController, GKGameCenterControllerDelegate {
//    
//    let leaderboardIdentifier = "Glug"
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        authenticateLocalPlayer()
//    }
//    
//    func authenticateLocalPlayer() {
//        let localPlayer = GKLocalPlayer.localPlayer()
//        localPlayer.authenticateHandler = { (viewController, error) -> Void in
//            if let viewController = viewController {
//                self.presentViewController(viewController, animated: true, completion: nil)
//            }
//        }
//    }
//    
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
//    
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
//    
//    
//    
////    @IBAction func saveProgressButtonPressed(sender: UIButton) {
////        
////        saveHighScore(170)//подставить реальный счет
////        
////        showLeader()//Показать таблицу
////    }
//    
//}