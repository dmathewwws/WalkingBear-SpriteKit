//
//  GameScene.swift
//  WalkingBear
//
//  Created by Daniel Mathews on 2015-04-21.
//  Copyright (c) 2015 ca.lighthouselabs. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var bear:SKSpriteNode!
    var bearWalkingFrames:[SKTexture]!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        backgroundColor = UIColor.blackColor()
        
        let bearAnimatedAtlas = SKTextureAtlas(named: "BearImages")
        var walkFrames = [SKTexture]()
        
        let numImages = bearAnimatedAtlas.textureNames.count/2
        for var i = 1; i < numImages; i++ {
            let bearTextureName = "bear\(i)"
            walkFrames.append(bearAnimatedAtlas.textureNamed(bearTextureName))
        }
        
        bearWalkingFrames = walkFrames
        
        let firstFrame = bearWalkingFrames[0]
        bear = SKSpriteNode(texture: firstFrame)
        bear.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        addChild(bear)
        
        
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        // Choose one of the touches to work with
        
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        
        var directionMultiplier:CGFloat
        
        let bearVelocity = self.frame.size.width / 3.0
        
        let moveDifference = CGPointMake(location.x - bear.position.x, location.y - bear.position.y)
        let distanceToMove = sqrt(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y)
        
        let moveDuration = distanceToMove / bearVelocity
        
        if moveDifference.x < 0 {
            directionMultiplier = 1.0
        } else {
            directionMultiplier = -1.0
        }
        
        bear.xScale = fabs(bear.xScale) * directionMultiplier
        
        if bear.actionForKey("bearMoving") != nil {
            bear.removeActionForKey("bearMoving")
        }
        
        if (bear.actionForKey("bearWalkingInPlace") == nil) {
            walkingBear()
        }
        
        let moveAction = SKAction.moveTo(location, duration: Double(moveDuration))
        
        let doneAction = SKAction.runBlock { () -> Void in
            println("Animation Completed")
            self.bearMoveEnded()
        }
        
        let moveActionWithDone = SKAction.sequence([moveAction, doneAction])
        bear.runAction(moveActionWithDone, withKey: "bearMoving")
        
        
    }
    
    func walkingBear(){
        
        bear.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(bearWalkingFrames, timePerFrame: 0.1)), withKey: "bearWalkingInPlace")
        
    }
    
    func bearMoveEnded(){
        bear.removeAllActions()

    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
