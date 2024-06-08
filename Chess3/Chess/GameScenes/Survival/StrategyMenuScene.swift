//
//  StrategyMenu.swift
//  Chess
//
//  Created by William Becht on 4/4/22.
//

import Foundation
import SpriteKit

class StrategyMenuScene: SKScene {
    var selectedStrategy = ""
    
    let defensesLabel = UILabel()
    let openingsLabel = UILabel()
    let chooseLabel = UILabel()
    let continueButton = UIButton(type: .roundedRect)
    let londonButton = UIButton(type: .roundedRect)
    let menuButtonNew = UIButton()
    let settingsButton = UIButton()
    var london = true
    
    override func didMove(to view: SKView) {
        
        // CREATING NAV BARS
        //let boardSize = boardMult*frame.width
        //let blackSquare1 = SKSpriteNode(imageNamed: "blackSquare")
        //blackSquare1.size = CGSize(width: boardSize*1.5, height: boardSize/4)
        //blackSquare1.position = CGPoint(x: 0, y: boardSize)
        //blackSquare1.alpha = 0.6
        //blackSquare1.isUserInteractionEnabled = false
        //self.addChild(blackSquare1)
        
        //let blackSquare2 = SKSpriteNode(imageNamed: "blackSquare")
        //blackSquare2.size = CGSize(width: boardSize*1.5, height: boardSize/4)
        //blackSquare2.position = CGPoint(x: 0, y: -boardSize)
        //blackSquare2.alpha = 0.6
        //blackSquare2.isUserInteractionEnabled = false
        //self.addChild(blackSquare2)
        
        
        // CREATING CONTINUE BUTTON
        continueButton.frame = CGRect(x: 100.0, y: 700.0, width: 200.0, height: 52.0)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.addTarget(self, action: #selector(continueButtonClicked(_ :)), for: .touchUpInside)
        continueButton.layer.borderWidth = 1.0
        continueButton.layer.borderColor = UIColor.white.cgColor
        continueButton.backgroundColor = UIColor.lightGray
        continueButton.layer.cornerRadius = 20
        continueButton.titleLabel?.font = UIFont(name: "Esteban", size: 20)
        continueButton.setTitleColor(.darkGray, for: .normal)
        self.view!.addSubview(continueButton)
        
        
        // CREATING LONDON BUTTON
        londonButton.frame = CGRect(x: 20.0, y: 250.0, width: 150, height: 52.0)
        londonButton.setTitle("London System", for: .normal)
        londonButton.addTarget(self, action: #selector(londonButtonClicked(_ :)), for: .touchUpInside)
        londonButton.layer.borderWidth = 1.0
        londonButton.layer.borderColor = UIColor.white.cgColor
        londonButton.backgroundColor = UIColor.lightGray
        londonButton.layer.cornerRadius = 20
        londonButton.titleLabel?.font = UIFont(name: "Esteban", size: 10)
        londonButton.setTitleColor(.darkGray, for: .normal)
        self.view!.addSubview(londonButton)
        
        // CREATING CHOOSE LABEL
        let fontsize = 55.0
        chooseLabel.frame = CGRect(x: 120.0, y: 150, width: 200.0, height: 52.0)
        chooseLabel.font = UIFont(name: "Esteban", size: fontsize)
        chooseLabel.text = "Select Strategy:"
        self.view!.addSubview(chooseLabel)
        
        
        // CREATING OPENINGS LABEL
        openingsLabel.frame = CGRect(x: 50.0, y: 200, width: 200.0, height: 52.0)
        openingsLabel.font = UIFont(name: "Esteban", size: fontsize)
        openingsLabel.text = "Openings:"
        self.view!.addSubview(openingsLabel)
        
        // CREATING DEFENSES LABEL
        defensesLabel.frame = CGRect(x: 250.0, y: 200, width: 200.0, height: 52.0)
        defensesLabel.font = UIFont(name: "Esteban", size: fontsize)
        defensesLabel.text = "Defenses:"
        self.view!.addSubview(defensesLabel)
        
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

    }
    
    @objc func settingsButtonClicked(_: UIButton) {
        removeObjects()
        lastScene = "StrategyMenuScene"
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
    
    
    @objc func londonButtonClicked(_: UIButton) {
        if london {
            londonButton.layer.borderColor = UIColor.green.cgColor
            selectedStrategy = "London System"
        } else {
            londonButton.layer.borderColor = UIColor.white.cgColor
            selectedStrategy = ""
        }
        london = !london
    }
    
    
    @objc func continueButtonClicked(_: UIButton) {
        if selectedStrategy != "" {
            curFileList = filesDict[selectedStrategy]!
            removeObjects()
            let nextScene = GameScene(fileNamed: curSceneNext)!
            nextScene.scaleMode = .aspectFill
            scene?.view?.presentScene(nextScene)
            removeObjects()
        } else {
            continueButton.layer.borderColor = UIColor.red.cgColor
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                continueButton.layer.borderColor = UIColor.white.cgColor
            }
        }
    }

    
    func removeObjects() {
        continueButton.removeFromSuperview()
        londonButton.removeFromSuperview()
        settingsButton.removeFromSuperview()
        menuButtonNew.removeFromSuperview()
        openingsLabel.removeFromSuperview()
        defensesLabel.removeFromSuperview()
        chooseLabel.removeFromSuperview()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
