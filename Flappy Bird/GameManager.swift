//
//  GameManager.swift
//  Flappy Bird
//
//  Created by Caroline Davis on 14/03/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import Foundation


class GameManager {
    
    // creates the singleton
    static let instance = GameManager()
    private init() {}
    
    var birdIndex = Int(0)
    var birds = ["Blue", "Green", "Red"]
    
    func incrementIndex() {
        birdIndex += 1
        // if the index is 3 then it will go back to 0 to avoid crashing and allowing it to go up to 4 etc
        if birdIndex == birds.count {
            birdIndex = 0
        }
    }
    
    func getBird() -> String {
        return birds[birdIndex]
    }
    
    // saving the data for the score
    func setHighscore(highscore: Int) {
        
        UserDefaults.standard.set(highscore, forKey: "Highscore")
    }
    
    func getHighscore() -> Int {
        return UserDefaults.standard.integer(forKey: "Highscore")
    }
   
}










