//
//  GameViewController.swift
//  spriteGaming
//
//  Created by Oliver Huber and Caroline Badoud
//  Workshop 6 - FS16 - June 2016
//  Copyright © 2016 FHNW. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /*create the game scene
        the game scene is taking place in the MainMenu-File
        that will be the first window that will be called
        by lauching the application */
        
        //The File MainMenu is wrapped into a GameScene
        //within this if-statement
        if let scene = GameScene(fileNamed:"MainMenu") {
            // Configure the view.
            let skView = self.view as! SKView
            // show fps and node count on screen
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            // improves the control of the Z-Position
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            // AspectFit makes it compatible
            // with other phone resolutions
            // working with letterbox
            // to display in different aspect ratios
            scene.scaleMode = .AspectFit
            
            // shows the spritekit scene
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
