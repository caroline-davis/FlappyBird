//
//  GameplayScene.swift
//  Flappy Bird
//
//  Created by Caroline Davis on 7/03/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import SpriteKit

class GameplayScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = Bird()
    
    var pipesHolder = SKNode()
    var scoreLabel = SKLabelNode(fontNamed: "04b_19")
    var score = 0
    
    var gameStarted = false
    var isAlive = false
    
    var press = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        initialize()

    }
    
    override func update(_ currentTime: TimeInterval) {
        if isAlive {
        moveBackgroundsAndGrounds()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // this is the first time we touch the screen - isAlive becomes true and everything starts
        if gameStarted == false {
            isAlive = true
            gameStarted = true
            press.removeFromParent()
            spawnObstacles()
            bird.physicsBody?.affectedByGravity = true
            bird.flap()
        }
        if isAlive {
            bird.flap()
        }
        for touch in touches {
            // gets the location of the touch in the scene
            let location = touch.location(in: self)
            
            if atPoint(location).name == "Retry" {
               // restart the game
                self.removeAllActions()
                self.removeAllChildren()
                initialize()
            }
            
            if atPoint(location).name == "Quit" {
                    let mainMenu = MainMenuScene(fileNamed: "MainMenuScene")
                    mainMenu?.scaleMode = .aspectFill
                    // presents mainmenu scene view controller
                    self.view?.presentScene(mainMenu!, transition: SKTransition.doorway(withDuration: 1))
            }
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        // there is no way to determine that bodyA is always the bird - we have to do this if statement
        if contact.bodyA.node?.name == "Bird" {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.node?.name == "Bird" && secondBody.node?.name == "Score" {
            incrementScore()
        } else if firstBody.node?.name == "Bird" && secondBody.node?.name == "Pipe" {
            
            if isAlive {
                birdDied()
            }
            } else if firstBody.node?.name == "Bird" && secondBody.node?.name == "Ground" {
            
            if isAlive {
                birdDied()
            }
            }
    }
    
    func initialize() {
        
        // when you restart the game, everything resets as the scene itself is not refreshed.
        gameStarted = false
        isAlive = false
        score = 0
        
        physicsWorld.contactDelegate = self
        
        createInstructions()
        createBirds()
        createBackgrounds()
        createGrounds()
        createLabel()
        
    }
    
    
    func createInstructions() {
        press = SKSpriteNode(imageNamed: "Press")
        press.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        press.position = CGPoint(x: 0, y: 0)
        press.setScale(1.8)
        press.zPosition = 10
        self.addChild(press)
        
    }
    
    
    
    func createBirds() {
        bird = Bird(imageNamed: "\(GameManager.instance.getBird()) 1")
        bird.initalize()
        bird.position = CGPoint(x: -50, y: 0)
        self.addChild(bird)
    }
    
    func createBackgrounds(){
        // loop 3 times
        for i in 0...2 {
            let bg = SKSpriteNode(imageNamed: "BG Day")
            bg.name = "BG"
            bg.zPosition = 0
            bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            // this moves the screen across from the x position which is the changing position.
            bg.position = CGPoint(x: CGFloat(i) * bg.size.width, y: 0)
            self.addChild(bg)
        }
    }
    
    func createGrounds() {
        for i in 0...2 {
            let ground = SKSpriteNode(imageNamed: "Ground")
            ground.name = "Ground"
            ground.zPosition = 4
            ground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            // this puts the ground at the middle, then the minus will put it at the bottom
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: -(self.frame.size.height / 2))
            // be aware that if this has a "?" after physicsBody then it won't work!!!!!
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            ground.physicsBody?.affectedByGravity = false
            // makes the ground static so other phsyicsbodys cant move it
            ground.physicsBody?.isDynamic = false
            ground.physicsBody?.categoryBitMask = ColliderType.Ground
          
        //  Dont need this here because its already in the bird.swift file
        //  ground.physicsBody?.collisionBitMask = ColliderType.Bird
        //  ground.physicsBody?.contactTestBitMask = ColliderType.Bird
            self.addChild(ground)
        }
    }
    
    
    func moveBackgroundsAndGrounds () {
        // moves bground
        enumerateChildNodes(withName: "BG", using: ({
        (node, error) in
            // code here will be executed for children specified in withName
        
            // this will move every node 4.5 to the left side
            node.position.x -= 4.5
            
            if node.position.x < -(self.frame.width) {
                // times by 3 because there are 3 backgrounds in the gameplayscene.sks
                node.position.x += self.frame.width * 3
            }
            
        }))
        
        // moves ground
        enumerateChildNodes(withName: "Ground", using: ({
            (node, error) in
            // code here will be executed for children specified in withName
            
            // this will move every node 2.5 to the left side
            node.position.x -= 2
            
            if node.position.x < -(self.frame.width) {
                // times by 3 because there are 3 backgrounds in the gameplayscene.sks
                node.position.x += self.frame.width * 3
            }
            
        }))

    }
    
    func createPipes() {
        
        pipesHolder = SKNode()
        pipesHolder.name = "Holder"
        
        let pipeUp = SKSpriteNode(imageNamed: "Pipe 1")
        let pipeDown = SKSpriteNode(imageNamed: "Pipe 1")
        
        let scoreNode = SKSpriteNode()
        
        // delete when the game is ready
        scoreNode.color = SKColor.red
        
        scoreNode.name = "Score"
        scoreNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scoreNode.position = CGPoint(x: 0, y: 0)
        scoreNode.size = CGSize(width: 5, height: 300)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.categoryBitMask = ColliderType.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
        
        
        
        pipeUp.name = "Pipe"
        pipeUp.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pipeUp.position = CGPoint(x: 0, y: 630)
        pipeUp.yScale = 1.5
        // this rotates the sprite 180 degrees
        pipeUp.zRotation = CGFloat(M_PI)
        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
        pipeUp.physicsBody?.categoryBitMask = ColliderType.Pipes
        pipeUp.physicsBody?.affectedByGravity = false
        // makes pipe static
        pipeUp.physicsBody?.isDynamic = false
        
        pipeDown.name = "Pipe"
        pipeDown.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pipeDown.position = CGPoint(x: 0, y: -630)
        pipeDown.yScale = 1.5
        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
        pipeDown.physicsBody?.categoryBitMask = ColliderType.Pipes
        pipeDown.physicsBody?.affectedByGravity = false
        // makes pipe static
        pipeDown.physicsBody?.isDynamic = false
        
        pipesHolder.zPosition = 5
        pipesHolder.position.x = self.frame.width + 100
        pipesHolder.position.y = CGFloat.randomBetweenNumbers(firstNum: -300, secondNum: 300)
        
        pipesHolder.addChild(pipeUp)
        pipesHolder.addChild(pipeDown)
        pipesHolder.addChild(scoreNode)
        
        self.addChild(pipesHolder)
        
        let destination = self.frame.width * 2
        let move = SKAction.moveTo(x: -destination, duration: TimeInterval(10))
        let remove = SKAction.removeFromParent()
        
        // run an action of 2 actions.. it will do the first action :move then do the second :remove.
        pipesHolder.run(SKAction.sequence([move, remove]), withKey: "Move")
        
    }
    
    func spawnObstacles() {
        
        // this blocky
        let spawn = SKAction.run({ () -> Void in
            self.createPipes()
        })
        
        // will spawn the pipes every 2 seconds
        let delay = SKAction.wait(forDuration: TimeInterval(2))
        let sequence = SKAction.sequence([spawn, delay])
        
        self.run(SKAction.repeatForever(sequence), withKey: "Spawn")
        
        
    }
    
    func createLabel() {
        scoreLabel.zPosition = 6
        scoreLabel.position = CGPoint(x: 0, y: 450)
        scoreLabel.fontSize = 120
        scoreLabel.text = "0"
        self.addChild(scoreLabel)
    }
    
    func incrementScore() {
        score += 1
        scoreLabel.text = String(score)
    }
    
    // kills the player when the bird hits
    func birdDied() {
        
        // stops spawning
        self.removeAction(forKey: "Spawn")
        
        for child in children {
            if child.name == "Holder" {
                child.removeAction(forKey: "Move")
            }
        }

        isAlive = false
        
        let highscore = GameManager.instance.getHighscore()
        if highscore < score {
            // if current score is greater than the saved highscore then we have a new highscore
            GameManager.instance.setHighscore(highscore: score)
        }
        
        // adds the bird died texture
        bird.texture = bird.diedTexture
        
        let retry = SKSpriteNode(imageNamed: "Retry")
        let quit = SKSpriteNode(imageNamed: "Quit")
        
        retry.name = "Retry"
        retry.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        retry.position = CGPoint(x: -150, y: -150)
        retry.zPosition = 7
        retry.setScale(0)
        
        quit.name = "Quit"
        quit.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        quit.position = CGPoint(x: 150, y: -150)
        quit.zPosition = 7
        quit.setScale(0)
        
        let scaleUp = SKAction.scale(to: 1, duration: (0.5))
        retry.run(scaleUp)
        quit.run(scaleUp)
        
        self.addChild(retry)
        self.addChild(quit)
    }
  
    
}
















