//
//  MainMenu.swift
//  spriteGaming
//
//  Created by Oliver Huber and Caroline Badoud
//  Workshop 6 - FS16 - June 2016
//  Copyright © 2016 FHNW. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    // the class MainMenu.sks has been associated to MainMenu.swift
    // by adding a customclass to the sks-file
    
    
    // enable transition between 
    // the differents scenes: MainMenu and GameScene
    override func touchesBegan(touches: Set<UITouch>, withEvent event:UIEvent?){
        // create gamescene, by finding and passing
        // the gamescene-sks-file to get loaded.
        let game:GameScene = GameScene(fileNamed: "GameScene")!
        
        // the scaleMode of MainMenu.swift
        // is matching with the scaleMode of GameViewController.swift
        // AspectFit make the screen size 
        // compatible with "older" iPhones
        game.scaleMode = .AspectFit
        // create a smooth transition, with a cross-fade
        let transition:SKTransition = SKTransition.crossFadeWithDuration(0.5)
        // load the scene, 
        // passing it the game, and the transition
        self.view?.presentScene(game, transition: transition)
        
    }


}
