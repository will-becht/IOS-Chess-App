//
//  GameViewController.swift
//  Chess
//
//  Created by William Becht on 3/2/22.
//

//import UIKit
import SpriteKit
import GameplayKit
//import GoogleMobileAds


class GameViewController: UIViewController {
    /*
    private let banner: GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = "ca-app-pub-9213997913758229/6699219223"
        banner.load(GADRequest())
        banner.backgroundColor = .secondarySystemBackground
        return banner
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = CGRect(x: 0, y: view.frame.size.height-50, width: view.frame.size.width, height: 50).integral
    }
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //banner.rootViewController = self
        //view.addSubview(banner)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "MenuScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = false
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
        
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
