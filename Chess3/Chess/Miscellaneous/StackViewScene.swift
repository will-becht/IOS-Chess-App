//
//  Menu.swift
//  Chess
//
//  Created by William Becht on 4/3/22.
//

import SpriteKit
import UIKit

protocol StackViewDelegate: AnyObject {
    func didTapOnView(at index: Int)
}

class GameMenuView: UIStackView {
    weak var delegate: StackViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .vertical
        self.distribution = .fillEqually
        self.alignment = .fill
        self.spacing = 5
        self.isUserInteractionEnabled = true
        //set up a label
        for i in 1...5 {
            let label = UILabel()
            label.text = "Menu voice \(i)"
            label.textColor = UIColor.white
            label.backgroundColor = UIColor.blue
            label.textAlignment = .center
            label.tag = i
            self.addArrangedSubview(label)
        }
        configureTapGestures()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureTapGestures() {
        arrangedSubviews.forEach { view in
            view.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
            view.addGestureRecognizer(tapGesture)
        }
    }
    @objc func didTapOnView(_ gestureRecognizer: UIGestureRecognizer) {
        if let index = arrangedSubviews.firstIndex(of: gestureRecognizer.view!) {
            delegate?.didTapOnView(at: index)
        }
    }
}
class StackViewScene: SKScene, StackViewDelegate {
    var gameMenuView = GameMenuView()
    private var label : SKLabelNode?
    override func didMove(to view: SKView) {
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        // Menu setup with stackView
        gameMenuView.frame=CGRect(x:20,y:50,width:280,height:200)
        view.addSubview(gameMenuView)
        gameMenuView.delegate = self
    }
    func didTapOnView(at index: Int) {
        switch index {
        case 0: print("tapped voice 1")
        case 1: print("tapped voice 2")
        case 2: print("tapped voice 3")
        case 3: print("tapped voice 4")
        case 4: print("tapped voice 5")
        default:break
        }
    }
}
