//
//  MainMenuScene.swift
//  Flappy Bird
//
//  Created by Caroline Davis on 14/03/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        initialize()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if atPoint(location).name == "Play" {
                let gameplay = GameplayScene(fileNamed: "GameplayScene")
                gameplay?.scaleMode = .aspectFill
                
                self.view?.presentScene(gameplay!, transition: SKTransition.doorway(withDuration: 1))

            }
            
            if atPoint(location).name == "Highscore" {
                
            }
        }
    }
    
    func initialize() {
        createBG()
        createButtons()
    }
    
    func createBG() {
        let bg = SKSpriteNode(imageNamed: "BG Day")
        bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bg.position = CGPoint(x: 0, y: 0)
        bg.zPosition = 0
        self.addChild(bg)
    }
    
    func createButtons() {
        let play = SKSpriteNode(imageNamed: "Play")
        let highscore = SKSpriteNode(imageNamed: "Highscore")
        
        play.name = "Play"
        play.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        play.position = CGPoint(x: -180, y: -50)
        play.zPosition = 1
        play.setScale(0.7)
        
        highscore.name = "Highscore"
        highscore.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        highscore.position = CGPoint(x: 180, y: -50)
        highscore.zPosition = 1
        highscore.setScale(0.7)
        
        self.addChild(play)
        self.addChild(highscore)
        

    }

    
    
    
    
}
