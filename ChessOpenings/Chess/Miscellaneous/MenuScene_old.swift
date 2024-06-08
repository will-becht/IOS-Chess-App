//
//  StartScene.swift
//  Chess
//
//  Created by William Becht on 3/11/22.
//

import SpriteKit
import Foundation

class MenuScene_old: SKScene {
    
    override func didMove(to view: SKView) {
        
        let xpos = 2.5
        let titleLabel = SKLabelNode(fontNamed:"Times New Roman")
        titleLabel.text = "Chess"
        titleLabel.name = "titleLabel"
        titleLabel.fontSize = 60
        titleLabel.position = CGPoint(x:self.frame.midX, y:(frame.midY+frame.maxY)/2)
        self.addChild(titleLabel)
        
        let botLabel = SKLabelNode(fontNamed:"Times New Roman")
        botLabel.text = "Bot"
        botLabel.name = "Bot"
        botLabel.fontSize = 45
        botLabel.position = CGPoint(x:self.frame.midX, y:frame.minY + (frame.height/8))
        self.addChild(botLabel)
        
        let ypos = (frame.midY+frame.maxY)/3
        let openingsLabel = SKLabelNode(fontNamed:"Times New Roman")
        openingsLabel.text = "Openings"
        openingsLabel.name = "openingsLabel"
        openingsLabel.fontSize = 45
        openingsLabel.position = CGPoint(x:-(frame.midX+frame.maxX)/xpos, y:ypos)
        self.addChild(openingsLabel)
        
        let defensesLabel = SKLabelNode(fontNamed:"Times New Roman")
        defensesLabel.text = "Defenses"
        defensesLabel.name = "defensesLabel"
        defensesLabel.fontSize = 45
        defensesLabel.position = CGPoint(x:(frame.midX+frame.maxX)/xpos, y:ypos)
        self.addChild(defensesLabel)
        
        var iter = 80
        for curOpening in openingsList {
            let node = SKLabelNode(fontNamed:"Times New Roman")
            node.text = curOpening
            node.name = curOpening
            node.fontSize = 30
            node.position = CGPoint(x: -(frame.midX+frame.maxX)/xpos, y: ypos-CGFloat(iter))
            self.addChild(node)
            iter += 80
        }
        
        iter = 80
        for curOpening in defensesList {
            let node = SKLabelNode(fontNamed:"Times New Roman")
            node.text = curOpening
            node.name = curOpening
            node.fontSize = 30
            node.position = CGPoint(x: (frame.midX+frame.maxX)/xpos, y: ypos-CGFloat(iter))
            self.addChild(node)
            iter += 80
        }
        
        
        // adding nav bar
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: -100))
        self.view!.addSubview(navBar)
        let navItem = UINavigationItem(title: "SomeTitle")
        navBar.setItems([navItem], animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let nodeTouched = nodes(at: touch.location(in: self)).first ?? SKNode()
            if nodeTouched.isKind(of: SKLabelNode.self) {
                let name = nodeTouched.name!
                curTitle = name
                if defensesList.contains(name) || openingsList.contains(name) {
                    curFileList = filesDict[name]!
                    let nextScene = GameScene(fileNamed: "LevelScene")!
                    nextScene.scaleMode = .aspectFill
                    scene?.view?.presentScene(nextScene)
                } else {
                    let nextScene = GameScene(fileNamed: "GameSceneBot")!
                    nextScene.scaleMode = .aspectFill
                    scene?.view?.presentScene(nextScene)
                }
            }
        }
    }
}
