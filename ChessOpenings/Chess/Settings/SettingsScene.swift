//
//  SettingsScene.swift
//  Chess
//
//  Created by William Becht on 4/5/22.
//

import Foundation
import SpriteKit

class SettingsScene: SKScene {
    
    let menuButtonNew = UIButton()

    override func didMove(to view: SKView) {
        // CREATING BACK BUTTON
        let buttonSize = 40.0
        let largeConfig = UIImage.SymbolConfiguration(pointSize: buttonSize, weight: .medium, scale: .default)
        let largeBoldDoc = UIImage(systemName: "arrowshape.turn.up.left.circle.fill", withConfiguration: largeConfig)
        menuButtonNew.setImage(largeBoldDoc, for: .normal)
        menuButtonNew.frame = CGRect(x: 10, y: 100, width: buttonSize, height: buttonSize)
        menuButtonNew.layer.cornerRadius = 0.5 * menuButtonNew.bounds.size.width
        menuButtonNew.clipsToBounds = true
        menuButtonNew.addTarget(self, action: #selector(menuButtonNewClicked(_ :)), for: .touchUpInside)
        self.view!.addSubview(menuButtonNew)
        
        
        /* ANIMATING THE MOVEMENT OF A LABEL
        let label = UILabel()
        label.frame = CGRect(x: 150, y: 300, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .white
        self.view!.addSubview(label)
        
        UIView.animate(withDuration: 5) {
             label.frame = CGRect(x: 150, y: 600, width: 200, height: 20)
        }
         */
    }
    
    @objc func menuButtonNewClicked(_: UIButton) {
        removeObjects()
        let nextScene = GameScene(fileNamed: lastScene)!
        nextScene.scaleMode = .aspectFill
        scene?.view?.presentScene(nextScene)
    }
    
    func removeObjects() {
        menuButtonNew.removeFromSuperview()
    }
}
