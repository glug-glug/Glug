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
    
    enum Errors: ErrorType {
        case NoConnection
        case NotAuthenticated
    }
    
    override init() {
        super.init()
        player
    }
    
    private var player: GKLocalPlayer {
        let p = GKLocalPlayer.localPlayer()
        p.authenticateHandler = { _ in }
        return p
    }
    
    private var isConnected: Bool {
        return UIDevice.isConnectedToNetwork
    }
    
    private var isAuthenticated: Bool {
        return player.authenticated
    }
    
    private func check() throws {
        guard isConnected else {
            throw Errors.NoConnection
        }
        guard isAuthenticated else {
            throw Errors.NotAuthenticated
        }
    }

    // MARK: -
    
    private func openSettings() {
        openUrl("gamecenter:")
    }

    // MARK: -
    
    func showLeader() {

        do {
            try check()
        } catch Errors.NotAuthenticated {
            openSettings()
            return
        } catch {
            return
        }
        
        let vc = GKGameCenterViewController()
        vc.gameCenterDelegate = self
        vc.viewState = .Leaderboards
        vc.leaderboardIdentifier = leaderboardIdentifier
        present(vc)
    }
    
    func reportScore(score: Score) {

        guard let _ = try? check() else {
            return
        }
        
        let gkScore = GKScore(leaderboardIdentifier: leaderboardIdentifier)
        gkScore.value = Int64(score)
        gkScore.shouldSetDefaultLeaderboard = true
        
        GKScore.reportScores([gkScore], withCompletionHandler: nil)
    }

    // MARK: -
    
    private func present(vc: UIViewController?) {
        guard let vc = vc else {
            return
        }
        UIApplication.rootViewController?.presentViewController(vc, animated: true, completion: nil)
    }
}

extension GCService: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
