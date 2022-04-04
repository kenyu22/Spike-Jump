//
//  StartScene.swift
//  Spike Jumper
//
//  Created by Kenny on 12/29/17.
//  Copyright © 2017 Kenny. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

var playButton = SKSpriteNode()
var playTitle = SKLabelNode()

var startButton = SKLabelNode()

class StartScene: SKScene {
    
    override func didMove(to view: SKView) {
        startButton()
        
    }
    func startButton() {
        
        playTitle = SKLabelNode()
        playTitle.fontName = "Futura"
        playTitle.color = .white
        playTitle.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 400)
        playTitle.fontSize = 70
        playTitle.text = "PLAY"
        self.addChild(playTitle)
        
        playButton = SKSpriteNode(imageNamed: "wow2")
        playButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 500)
        playButton.size = CGSize(width: 200, height: 200)
        
        self.addChild(playButton)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if playButton.contains(location) {
                let sceneGame = GameScene(fileNamed: "GameScene")
                sceneGame?.scaleMode = .aspectFill
                self.view?.presentScene(sceneGame!, transition: SKTransition.fade(with: .black, duration: 0.2))
                

                
            }
        }
    }
}
