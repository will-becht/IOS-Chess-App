//
//  LevelScene.swift
//  Chess
//
//  Created by William Becht on 3/20/22.
//

import Foundation
import SpriteKit

class LevelScene: SKScene {
    
    let label = UILabel()
    let scrollView = UIScrollView()
    
    override func didMove(to view: SKView) {
        label.text = "Tap a button"
                
        // center the text in the label
        label.textAlignment = .center
        
        // so we can see the frames
        label.backgroundColor = .yellow
        scrollView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        // create a vertical stack view to hold the rows of buttons
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical

        // we're going to use auto-layout
        label.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // add label to view
        self.view!.addSubview(label)
        
        // add Scrollview to view
        self.view!.addSubview(scrollView)
        
        // add stack view to scrollView
        scrollView.addSubview(verticalStackView)

        // now let's create the buttons and add them
        var idx = 1
        
        for _ in 0...90 {
            // create a "row" stack view
            let rowStack = UIStackView()
            // add it to the vertical stack view
            verticalStackView.addArrangedSubview(rowStack)
            
            for _ in 0...2 {
                if idx <= curFileList.count {
                    let button = UIButton()
                    button.backgroundColor = .gray
                    button.setTitle("\(idx)", for: .normal)
                    button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                    
                    // add button to row stack view
                    rowStack.addArrangedSubview(button)
                    
                    // buttons should be 50x50
                    NSLayoutConstraint.activate([
                        button.widthAnchor.constraint(equalToConstant: 50.0),
                        button.heightAnchor.constraint(equalToConstant: 50.0),
                    ])
                    

                }
                idx += 1
            }
        }
        
        // finally, let's set our constraints
                
        // respect safe-area
        let safeG = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            
            // constrain label
            //  50-pts from top
            //  100% of the width
            //  centered horizontally
            label.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 50.0),
            label.widthAnchor.constraint(equalTo: safeG.widthAnchor, multiplier: 1),
            label.centerXAnchor.constraint(equalTo: safeG.centerXAnchor),
            
            // constrain scrollView
            //  50-pts from bottom of label
            //  Leading and Trailing to safe-area with 8-pts "padding"
            //  Bottom to safe-area with 8-pts "padding"
            scrollView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 50.0),
            scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 8.0),
            scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -8.0),
            scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: -8.0),
            
            // constrain vertical stack view to scrollView Content Layout Guide
            //  8-pts all around (so we have a little "padding")
            verticalStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 8.0),
            verticalStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 8.0),
            verticalStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -8.0),
            verticalStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -8.0)])
        
        // suppose we want 8-pts spacing between the buttons?
        verticalStackView.spacing = 8.0
        verticalStackView.arrangedSubviews.forEach { v in
            if let stack = v as? UIStackView {
                stack.spacing = 8.0
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        label.text = sender.title(for: .normal)
        
        // removing the entire level scene
        for view in self.view!.subviews as [UIView] {
            view.removeFromSuperview()
        }
        chosenLevel = Int(sender.title(for: .normal)!)!-1
        
        let nextScene = GameScene(fileNamed: "GameScene")!
        nextScene.scaleMode = .aspectFill
        scene?.view?.presentScene(nextScene)
    }
    /*
    let nextScene = GameScene(fileNamed: "LevelScene")!
    nextScene.scaleMode = .aspectFill
    scene?.view?.presentScene(nextScene)*/
}
