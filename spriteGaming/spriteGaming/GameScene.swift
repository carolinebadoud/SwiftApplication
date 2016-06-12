//
//  GameScene.swift
//  spriteGaming
//
//  Created by Oliver Huber and Caroline Badoud
//  Workshop 6 - FS16 - June 2016
//  Copyright © 2016 FHNW. All rights reserved.
//

import SpriteKit

// Each object has a dinsticted category mask (see object editor)
// Those are referenced here to define their reaction on a collision
// Hexidecimal increase readibility later in the code
let wallMask:UInt32 = 0x1 << 0 // 1
let ballMask:UInt32 = 0x1 << 1 // 2
let pegMask:UInt32 = 0x1 << 2 // 4
let bucketMask:UInt32 = 0x1 << 3 // 8


// In Order to control the collisions and 
// and react to collision detection,
// GameScene is a delegate of SKPhysicsContactDelegate
class GameScene: SKScene , SKPhysicsContactDelegate{
    
    var cannon:SKSpriteNode!
    var touchLocation:CGPoint = CGPointZero
    
    var ball:SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // get node named "cannon"
        cannon = self.childNodeWithName("cannon_full") as! SKSpriteNode
        // delegate the scene itself as a physical world for collision detection
        self.physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        // get the location of the touch on screen
        // in coordinate space
        touchLocation = touches.first!.locationInNode(self)
        
        
     
        // We give the ball an impulse
        // the impulse is declared as a vector
        // our vector is shooting the ball on the air (dy:100) wenn the user touch the screen (touchesBegan), every frame
        //ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchLocation = touches.first!.locationInNode(self)
    }
    
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Add the balls
        // We are loading the child-object "ball"
        // from the SKScene-File "Ball"
        let ball:SKSpriteNode = SKScene(fileNamed: "Ball")?.childNodeWithName("ball")! as! SKSpriteNode
        
        
        // Remove the object "ball" from its parent-scene
        // add asign it to the actual scene
        ball.removeFromParent()
        self.addChild(ball)
        
        // The balls goes on the back, behind the cannon
        ball.zPosition = 0
        
        // Move the ball to the right position
        // The source position of the balls
        // are the cannon
        ball.position = cannon.position
        
        // The balls ared fired out of the cannon.
        // the angle of the impulse of the balls is
        // based on the rotation of the canon.
        // get angle in radians of the rotation of the canon
        let angleInRadians = Float(cannon.zRotation)
        
        // speed, define how fast the balls are moving
        let speed = CGFloat(75.0)
        
        // calculate velocity x
        // get the cosinus of the angle to get the x velocity (= speed in x-direction)
        // get the sinus of the angle to get the y velocity
        let vx:CGFloat;
        vx = CGFloat(cosf(angleInRadians)) * speed
        let vy:CGFloat;
        vy = CGFloat(sinf(angleInRadians)) * speed
        
        // Apply the impulse to the object ball
        // Forces => Applied over time (motor in a car)
        // Impulse => applied just one time
        ball.physicsBody?.applyImpulse(CGVector(dx: vx, dy: vy))
        // Applies the reaction to a collision
        // List the objects the ball has to collide with
        ball.physicsBody?.collisionBitMask = wallMask | ballMask | pegMask | bucketMask
        
        // set the contact test bitmask
        // define which objects should react to a collision
        // the contact mask takes the value of the defined collision mask
        // call of didBeginnContact happens
        ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        /* Rotate the cannon in relation to the position of the touches */
        // touches coordinates in percent
        let percent = touchLocation.x / size.width
        // rotation on a range of 180 degrees
        let newAngle = percent * 180 - 180
        // calculated Rotation for the cannon, as a float
        cannon.zRotation = CGFloat(newAngle) * CGFloat(M_PI) / 180.0
        
    }
    
    
    // called when two bodies first contact each other
    func didBeginContact(contact: SKPhysicsContact) {
        // "contact" contains the two physics bodies that entered in contact
        // The ball is the only object that notificate about a contact
        // The contact mask for the walls and the pegs and the buckets has been set to zero
        // They does not notificate a contact
        // determine which is the ball: if...
        
        let ball = (contact.bodyA.categoryBitMask == ballMask) ? contact.bodyA : contact.bodyB
        let other = (ball == contact.bodyA) ? contact.bodyB : contact.bodyA
        
        // if ball enter in contact with peg
        if other.categoryBitMask == pegMask {
            // let it disapear from screen
            other.node?.removeFromParent()
        }
    }
    
    
    
    
    
}
