//
//  MenuScene.swift
//  Chess
//
//  Created by William Becht on 3/29/22.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    
    let learnButton = UIButton(type: .roundedRect)
    let survivalButton = UIButton(type: .roundedRect)
    let botButton = UIButton(type: .roundedRect)
    let imageView = UIImageView(image: UIImage(named: "menuLogo2")!)
    let settingsButton = UIButton()
    
    override func didMove(to view: SKView) {
        
        // CREATING NAV BARS
        //let boardSize = boardMult*frame.width
        //let blackSquare1 = SKSpriteNode(imageNamed: "blackSquare")
        // blackSquare1.size = CGSize(width: boardSize*1.5, height: boardSize/4)
        //blackSquare1.position = CGPoint(x: 0, y: boardSize)
        //blackSquare1.alpha = 0.6
        //blackSquare1.isUserInteractionEnabled = false
        //self.addChild(blackSquare1)
        
        //let blackSquare2 = SKSpriteNode(imageNamed: "blackSquare")
        //blackSquare2.size = CGSize(width: boardSize*1.5, height: boardSize/4)
        // blackSquare2.position = CGPoint(x: 0, y: -boardSize)
        // blackSquare2.alpha = 0.6
        // blackSquare2.isUserInteractionEnabled = false
        // self.addChild(blackSquare2)
        
        // CREATING LOGO
        let logoSize = 420
        imageView.frame = CGRect(x: -5, y: 130, width: logoSize, height: logoSize)
        self.view!.addSubview(imageView)
        
        // CREATING BUTTONS
        var buttonConfig = UIButton.Configuration.plain()
        let buttonXLoc = 100.0
        let buttonWidth = 200.0
        let buttonHeight = 52.0
        
        // CREATING LEARN BUTTON
        buttonConfig.image = UIImage(systemName: "graduationcap") // or checkerboard.shield or hourglass
        buttonConfig.imagePlacement = .leading
        buttonConfig.imagePadding = 10
        learnButton.configuration = buttonConfig
        learnButton.frame = CGRect(x: buttonXLoc, y: 450.0, width: buttonWidth, height: buttonHeight)
        learnButton.setTitle("Learn", for: .normal)
        learnButton.addTarget(self, action: #selector(learnButtonClicked(_ :)), for: .touchUpInside)
        learnButton.layer.borderWidth = 1.0
        learnButton.layer.borderColor = UIColor.white.cgColor
        learnButton.backgroundColor = UIColor.lightGray
        learnButton.layer.cornerRadius = 20
        learnButton.titleLabel?.font = UIFont(name: "Esteban", size: 20)
        learnButton.setTitleColor(.darkGray, for: .normal)
        //learnButton.setImage(UIImage(systemName: "graduationcap"), for: .normal)
        self.view!.addSubview(learnButton)
        //UIColor(red: 231.0/255.0, green: 78.0/255.0, blue: 53.0/255.0, alpha: 1.0)
        
        
        // CREATING SURVIVAL BUTTON
        buttonConfig.image = UIImage(systemName: "crown") // or checkerboard.shield or hourglass
        survivalButton.configuration = buttonConfig
        survivalButton.frame = CGRect(x: buttonXLoc, y: 525.0, width: buttonWidth, height: buttonHeight)
        survivalButton.setTitle("Survival", for: .normal)
        survivalButton.addTarget(self, action: #selector(survivalButtonClicked(_ :)), for: .touchUpInside)
        survivalButton.layer.borderWidth = 1.0
        survivalButton.layer.borderColor = UIColor.white.cgColor
        survivalButton.backgroundColor = UIColor.lightGray
        survivalButton.layer.cornerRadius = 20
        survivalButton.titleLabel?.font = UIFont(name: "Esteban", size: 20)
        survivalButton.setTitleColor(.darkGray, for: .normal)
        self.view!.addSubview(survivalButton)
        //UIColor(red: 231.0/255.0, green: 78.0/255.0, blue: 53.0/255.0, alpha: 1.0)
        
        // CREATING BOT BUTTON
        buttonConfig.image = UIImage(systemName: "globe") // or checkerboard.shield or hourglass
        botButton.configuration = buttonConfig
        botButton.frame = CGRect(x: buttonXLoc, y: 600.0, width: buttonWidth, height: buttonHeight)
        botButton.setTitle("Analysis", for: .normal)
        botButton.addTarget(self, action: #selector(botButtonClicked(_:)), for: .touchUpInside)
        botButton.layer.borderWidth = 1.0
        botButton.layer.borderColor = UIColor.white.cgColor
        botButton.backgroundColor = UIColor.lightGray
        botButton.layer.cornerRadius = 20
        botButton.titleLabel?.font = UIFont(name: "Esteban", size: 20)
        botButton.setTitleColor(UIColor.darkGray, for: .normal)
        //botButton.setImage(UIImage(systemName: "globe"), for: .normal)
        
        self.view!.addSubview(botButton)
        
        // CREATING SETTINGS BUTTON
        let buttonSize = 50.0
        let largeConfig = UIImage.SymbolConfiguration(pointSize: buttonSize, weight: .medium, scale: .default)
        let largeBoldDoc = UIImage(systemName: "gearshape.fill", withConfiguration: largeConfig)
        settingsButton.setImage(largeBoldDoc, for: .normal)
        settingsButton.frame = CGRect(x: 325, y: 100, width: buttonSize, height: buttonSize)
        settingsButton.layer.cornerRadius = 0.5 * settingsButton.bounds.size.width
        settingsButton.clipsToBounds = true
        settingsButton.addTarget(self, action: #selector(settingsButtonClicked(_ :)), for: .touchUpInside)
        settingsButton.tintColor = .white
        self.view!.addSubview(settingsButton)
    }
    
    @objc func learnButtonClicked(_: UIButton) {
        curSceneNext = "GameScene"
        removeObjects()
        goToScene(sceneName: "GameScene")
    }
    
    @objc func survivalButtonClicked(_: UIButton) {
        curSceneNext = "SurvivalScene"
        removeObjects()
        goToScene(sceneName: "StrategyMenuScene")
    }
    
    @objc func botButtonClicked(_: UIButton) {
        curSceneNext = "GameSceneBot"
        removeObjects()
        goToScene(sceneName: "GameSceneBot")
    }
    
    @objc func settingsButtonClicked(_: UIButton) {
        curSceneNext = "SettingsScene"
        removeObjects()
        lastScene = "MenuScene"
        goToScene(sceneName: "SettingsScene")
    }
    
    
    func removeObjects() {
        learnButton.removeFromSuperview()
        survivalButton.removeFromSuperview()
        botButton.removeFromSuperview()
        imageView.removeFromSuperview()
        settingsButton.removeFromSuperview()
    }
    
    func goToScene(sceneName: String) {
        let nextScene = GameScene(fileNamed: sceneName)!
        nextScene.scaleMode = .aspectFill
        scene?.view?.presentScene(nextScene)
    }
}
