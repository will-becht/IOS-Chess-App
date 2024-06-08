//
//  LearnMenuScene.swift
//  Chess
//
//  Created by William Becht on 4/5/22.
//

import Foundation
import SpriteKit

class LearnMenuScene: SKScene {
    let settingsButton = UIButton()
    let menuButtonNew = UIButton()

    override func didMove(to view: SKView) {
        // CREATING SETTINGS BUTTON
        let buttonSize2 = 50.0
        let largeConfig2 = UIImage.SymbolConfiguration(pointSize: buttonSize2, weight: .medium, scale: .default)
        let largeBoldDoc2 = UIImage(systemName: "gearshape.fill", withConfiguration: largeConfig2)
        settingsButton.setImage(largeBoldDoc2, for: .normal)
        settingsButton.frame = CGRect(x: 325, y: 100, width: buttonSize2, height: buttonSize2)
        settingsButton.layer.cornerRadius = 0.5 * settingsButton.bounds.size.width
        settingsButton.clipsToBounds = true
        settingsButton.addTarget(self, action: #selector(settingsButtonClicked(_ :)), for: .touchUpInside)
        settingsButton.tintColor = .white
        self.view!.addSubview(settingsButton)
        
        
        // CREATING MENU BUTTON
        let buttonSize = 40.0
        let largeConfig = UIImage.SymbolConfiguration(pointSize: buttonSize, weight: .medium, scale: .default)
        let largeBoldDoc = UIImage(systemName: "arrowshape.turn.up.left.circle.fill", withConfiguration: largeConfig)
        menuButtonNew.setImage(largeBoldDoc, for: .normal)
        menuButtonNew.frame = CGRect(x: 10, y: 100, width: buttonSize, height: buttonSize)
        menuButtonNew.layer.cornerRadius = 0.5 * menuButtonNew.bounds.size.width
        menuButtonNew.clipsToBounds = true
        menuButtonNew.addTarget(self, action: #selector(menuButtonNewClicked(_ :)), for: .touchUpInside)
        self.view!.addSubview(menuButtonNew)
    }
    
    @objc func settingsButtonClicked(_: UIButton) {
        removeObjects()
        lastScene = "LearnMenuScene"
        let nextScene = GameScene(fileNamed: "SettingsScene")!
        nextScene.scaleMode = .aspectFill
        scene?.view?.presentScene(nextScene)
    }
    
    
    @objc func menuButtonNewClicked(_: UIButton) {
        removeObjects()
        let nextScene = GameScene(fileNamed: "MenuScene")!
        nextScene.scaleMode = .aspectFill
        scene?.view?.presentScene(nextScene)
    }
    
    
    func removeObjects() {
        settingsButton.removeFromSuperview()
        menuButtonNew.removeFromSuperview()
    }
}
