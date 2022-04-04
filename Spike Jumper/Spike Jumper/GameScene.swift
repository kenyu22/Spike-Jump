//
//  GameScene.swift
//  Spike Jumper
//
//  Created by Kenny on 12/27/17.
//  Copyright © 2017 Kenny. All rights reserved.
//

import SpriteKit
import GameplayKit

var vBlock = SKSpriteNode()

var vSize = CGSize(width: 35, height: 1400)

var leftPlayer = SKSpriteNode()
var rightPlayer = SKSpriteNode()

var playerSize = CGSize(width: 60, height: 60)

var leftButton = SKSpriteNode()
var rightButton = SKSpriteNode()

var timerCount = 0

var Spike1 = SKSpriteNode()
var Spike2 = SKSpriteNode()

var offBlackColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
var offWhiteColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
var background1 = SKSpriteNode()
var background2 = SKSpriteNode()

var timer = Timer()

var timerNode = SKLabelNode()

var spikeSpeed = 4.4
var spikeSpeed2 = 4.4

var spike1SpawnRate = 1.5
var spike2SpawnRate = 1.5

var spikeSize = CGSize(width: 95, height: 95)

var isAlive = true

var touchLocation = CGPoint()

struct physicsCategory {
    static let leftPlayer : UInt32 = 0
    static let rightPlayer : UInt32 = 1
    static let Spike1 : UInt32 = 2
    static let Spike2 : UInt32 = 3
    static let vBlock : UInt32 = 4
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        resetGameVariablesOnStart()
        spawnTime()
        
        spawnBackground()
        spawnBackground2()
        spawnVBlock()
        
        spawnLeftButton()
        spawnRightButton()
        

        scheduledTimerWithTimeInterval()

        spawnSpike1()
        timerSpawnSpike1()
        spawnSpike2()
        timerSpawnSpike2()

        spawnLeftPlayer()
        spawnRightPlayer()

        }
    func spawnTime() {
        timerNode = SKLabelNode()
        timerNode.fontName = "Futura"
        timerNode.position = CGPoint(x: self.frame.midX - 200, y: self.frame.midY + 500)
        timerNode.fontColor = UIColor.darkGray
        timerNode.fontSize = 100
        timerNode.zPosition = 50
        
        timerNode.text = "\(timerCount)"
        
        self.addChild(timerNode)
    }
    func spawnBackground() {
        background1 = SKSpriteNode(imageNamed: "SJ_Blue")
        background1.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background1.zPosition = -5
        background1.size = CGSize(width: 1920, height: 1500)
        
        self.addChild(background1)
    }
    func spawnBackground2() {
        background2 = SKSpriteNode(imageNamed: "SJ_Red")
        background2.position = CGPoint(x: self.frame.midX + 960, y: self.frame.midY)
        background2.zPosition = -4
        background2.size = CGSize(width: 1920, height: 1500)
        
        self.addChild(background2)
    }
    func spawnLeftButton() {
        leftButton = SKSpriteNode()
        leftButton.size = CGSize(width: 356, height: 400)
        leftButton.color = .clear
        leftButton.position = CGPoint(x: self.frame.midX - 195, y: self.frame.midY - 420)
        self.addChild(leftButton)
    }
    func spawnRightButton() {
        rightButton = SKSpriteNode()
        rightButton.size = CGSize(width: 356, height: 400)
        rightButton.color = .clear
        rightButton.position = CGPoint(x: self.frame.midX + 195, y: self.frame.midY - 420)
        self.addChild(rightButton)
        
    }
    func resetTimer(){
        
        timer.invalidate()
    }
    func spawnLeftPlayer() {
        leftPlayer = SKSpriteNode(imageNamed: "SJ_BluePlayer")
        leftPlayer.size = CGSize(width: 60, height: 60)
        leftPlayer.position = CGPoint(x: self.frame.midX - 345, y: self.frame.midY + 310)
        leftPlayer.zPosition = 100
        leftPlayer.physicsBody = SKPhysicsBody(rectangleOf: playerSize)
        leftPlayer.physicsBody?.affectedByGravity = false
        leftPlayer.physicsBody?.allowsRotation = false
        leftPlayer.physicsBody?.categoryBitMask = physicsCategory.leftPlayer
        leftPlayer.physicsBody?.contactTestBitMask = physicsCategory.Spike1
        leftPlayer.physicsBody?.isDynamic = true
        
        leftPlayer.name = "leftPlayerName"
        
        self.addChild(leftPlayer)
    }
    func spawnRightPlayer() {
        rightPlayer = SKSpriteNode(imageNamed: "SJ_RedPlayer")
        rightPlayer.size = CGSize(width: 60, height: 60)
        rightPlayer.position = CGPoint(x: self.frame.midX + 345, y: self.frame.midY + 310)
        rightPlayer.zPosition = 100
        rightPlayer.physicsBody = SKPhysicsBody(rectangleOf: playerSize)
        rightPlayer.physicsBody?.affectedByGravity = false
        rightPlayer.physicsBody?.allowsRotation = false
        rightPlayer.physicsBody?.categoryBitMask = physicsCategory.rightPlayer
        rightPlayer.physicsBody?.contactTestBitMask = physicsCategory.Spike2
        rightPlayer.physicsBody?.isDynamic = true
        
        rightPlayer.name = "rightPlayerName"
        
        self.addChild(rightPlayer)
    }
    
    func spawnVBlock() {
        vBlock.size = CGSize(width: 35, height: 1400)
        vBlock.color = UIColor.black
        vBlock.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        vBlock.physicsBody = SKPhysicsBody(rectangleOf: vSize)
        vBlock.physicsBody?.affectedByGravity = false
        vBlock.physicsBody?.allowsRotation = false
        vBlock.physicsBody?.categoryBitMask = physicsCategory.vBlock
        vBlock.physicsBody?.contactTestBitMask = physicsCategory.Spike1 | physicsCategory.Spike2
        vBlock.physicsBody?.isDynamic = false
        
        self.addChild(vBlock)
        
    }
    
    func spawnSpike1() {
        let Spike12 = CGPoint(x: self.frame.midX - 44, y: -1000)
        let Spike11 = CGPoint(x: self.frame.midX - 350, y: -1000)
        let xPositions = [
            Spike11,
            Spike12
        ]
        let randomX = Int(arc4random_uniform(UInt32(xPositions.count)))
        
        if randomX == 0 {
            Spike1 = SKSpriteNode(imageNamed: "SJ_SpikeRight")
        } else if randomX == 1 {
            Spike1 = SKSpriteNode(imageNamed: "SJ_SpikeLeft")
        }
    
        Spike1.size = spikeSize
        Spike1.position = xPositions[randomX]
        Spike1.physicsBody = SKPhysicsBody(rectangleOf: spikeSize)
        Spike1.physicsBody?.affectedByGravity = false
        Spike1.physicsBody?.allowsRotation = false
        Spike1.physicsBody?.categoryBitMask = physicsCategory.Spike1
        Spike1.physicsBody?.contactTestBitMask = physicsCategory.leftPlayer
        Spike1.physicsBody?.isDynamic = false
        Spike1.name = "Spike1Name"
        
        moveSpike1Up()
        
        self.addChild(Spike1)
        
    }
    
    func moveSpike1Up() {
        let moveTo = SKAction.moveTo(y: 700, duration: spikeSpeed)
        let destroy = SKAction.removeFromParent()
        
        Spike1.run(SKAction.sequence([moveTo, destroy]))
        
    }
    
    func timerSpawnSpike1() {
        let wait = SKAction.wait(forDuration: spike1SpawnRate)
        let spawn = SKAction.run {
            if isAlive == true {
                self.spawnSpike1()
                
            }
        }
        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence))
    }
    func spawnSpike2() {
        let Spike11 = CGPoint(x: self.frame.midX + 44, y: -1000)
        let Spike12 = CGPoint(x: self.frame.midX + 350, y: -1000)
        let xPositions = [
            Spike12,
            Spike11
        ]
        let randomX2 = Int(arc4random_uniform(UInt32(xPositions.count)))
        
        if randomX2 == 0 {
            Spike2 = SKSpriteNode(imageNamed: "SJ_SpikeLeft")
        } else if randomX2 == 1 {
            Spike2 = SKSpriteNode(imageNamed: "SJ_SpikeRight")
        }
        
        Spike2.size = spikeSize
        Spike2.position = xPositions[randomX2]
        Spike2.physicsBody = SKPhysicsBody(rectangleOf: spikeSize)
        Spike2.physicsBody?.affectedByGravity = false
        Spike2.physicsBody?.allowsRotation = false
        Spike2.physicsBody?.categoryBitMask = physicsCategory.Spike2
        Spike2.physicsBody?.contactTestBitMask = physicsCategory.rightPlayer
        Spike2.physicsBody?.isDynamic = false
        Spike2.name = "Spike2Name"
        
        moveSpike2Up()
        
        self.addChild(Spike2)
        
    }
    
    func moveSpike2Up() {
        let delayInSeconds = 3.567
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            
            let moveTo = SKAction.moveTo(y: 700, duration: spikeSpeed2)
            let destroy = SKAction.removeFromParent()
            
            Spike2.run(SKAction.sequence([moveTo, destroy]))
        }
        
    }
    
    func timerSpawnSpike2() {
        let wait = SKAction.wait(forDuration: spike2SpawnRate)
        let spawn = SKAction.run {
            if isAlive == true {
                self.spawnSpike2()
                
            }
        }
        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence))
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        timerCount = timerCount + 1
        timerNode.text = "\(timerCount)"
        print(timerCount)
    }
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if ((firstBody.categoryBitMask == physicsCategory.leftPlayer) && (secondBody.categoryBitMask == physicsCategory.Spike1) || (firstBody.categoryBitMask == physicsCategory.Spike1) && (secondBody.categoryBitMask == physicsCategory.leftPlayer)) {
            leftPlayerContact(contactA: firstBody.node as! SKSpriteNode, contactB: secondBody.node as! SKSpriteNode)
            
        }
        if ((firstBody.categoryBitMask == physicsCategory.rightPlayer) && (secondBody.categoryBitMask == physicsCategory.Spike2) || (firstBody.categoryBitMask == physicsCategory.Spike2) && (secondBody.categoryBitMask == physicsCategory.rightPlayer)) {
            rightPlayerContact(contactA: firstBody.node as! SKSpriteNode, contactB: secondBody.node as! SKSpriteNode)
        }
    }
    func leftPlayerContact(contactA: SKSpriteNode, contactB: SKSpriteNode) {
        if contactA.name == "leftPlayerName" && contactB.name == "Spike1Name" {
            isAlive = false
            gameOverLogic()
        }
        if contactB.name == "Spike1Name" && contactA.name == "leftPlayerName" {
            isAlive = false
            gameOverLogic()
        }
    }
    
    func rightPlayerContact(contactA: SKSpriteNode, contactB: SKSpriteNode) {
        if contactA.name == "rightPlayerName" && contactB.name == "Spike2Name" {
            isAlive = false
            gameOverLogic()
        }
        
        if contactB.name == "Spike2Name" && contactA.name == "rightPlayerName" {
            isAlive = false
            gameOverLogic()
        }
    }
    func gameOverLogic() {
        resetTheGame()
    }
    func resetTheGame() {
        let wait = SKAction.wait(forDuration: 1.0)
        let theTitleScene = StartScene(fileNamed: "StartScene")
        theTitleScene?.scaleMode = .aspectFill
        let theTransition = SKTransition.crossFade(withDuration: 0.4)
        
        let changeScene = SKAction.run {
            self.scene?.view?.presentScene(theTitleScene!, transition: theTransition)
            
        }
        let sequence = SKAction.sequence([wait, changeScene])
        self.run(SKAction.repeat(sequence, count: 1))
        
    }
    func resetGameVariablesOnStart() {
        resetTimer()
        
        isAlive = true
        
        timerCount = 0
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchLocation = touch.location(in: self)
            if isAlive == true {
                movePlayerOnTouch()
            }
            
        }
        
        
    }
    
    func movePlayerOnTouch() {
        let position1 = CGPoint(x: self.frame.midX - 48, y: self.frame.midY + 310)
        let position2 = CGPoint(x: self.frame.midX + 47, y: self.frame.midY + 310)
        
        if leftButton.contains(touchLocation) && leftPlayer.contains(leftPlayer.position) {
            //leftPlayer Movement
            leftPlayer.run(SKAction.moveTo(x: position1.x, duration: 0.5))
            
        }
        if leftButton.contains(touchLocation) && leftPlayer.contains(position1) {
            leftPlayer.run(SKAction.moveTo(x: -345, duration: 0.5))
        }
        
        if rightButton.contains(touchLocation) && rightPlayer.contains(rightPlayer.position) {
            //rightPlayer Movement
            rightPlayer.run(SKAction.moveTo(x: position2.x, duration: 0.5))
        }
        if rightButton.contains(touchLocation) && rightPlayer.contains(position2) {
    rightPlayer.run(SKAction.moveTo(x: 345, duration: 0.5))
        }
    }
    func movePlayerOffScreen() {
        leftPlayer.position.x = -500
        rightPlayer.position.x = 500
        Spike1.removeAllActions()
        Spike2.removeAllActions()
        vBlock.removeFromParent()
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if isAlive == false {
            movePlayerOffScreen()
        }
    }
}
