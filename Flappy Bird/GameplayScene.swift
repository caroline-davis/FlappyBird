//
//  GameplayScene.swift
//  Flappy Bird
//
//  Created by Caroline Davis on 7/03/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import SpriteKit

class GameplayScene: SKScene {
    
    var bird = Bird()
    
    override func didMove(to view: SKView) {
        initialize()
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveBackgroundsAndGrounds()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bird.flap()
    }
    
    func initialize() {
        createBirds()
        createBackgrounds()
        createGrounds()
        
    }
    
    func createBirds() {
        bird = Bird(imageNamed: "Blue 1")
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
    
    
}
