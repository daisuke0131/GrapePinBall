//
//  GameScene.swift
//  GrapePinBall
//
//  Created by daisuke on 2015/07/02.
//  Copyright (c) 2015年 daisuke. All rights reserved.
//

import SpriteKit

class GameScene: SKScene{
    
    var back = SKSpriteNode(imageNamed: "back")
    
    let grapesPosition:[(x:CGFloat,y:CGFloat)] = [(60.0,500.0),(160.0,500.0),(260.0,500.0),(110.0,400.0),(220.0,400.0)]
    
    let ball = SKSpriteNode(imageNamed: "ball")
    let board = SKSpriteNode(imageNamed: "board")
    var grapes:[Grape] = [Grape]()
    
    var bottom:SKShapeNode?
    
    var isStarted:Bool = false
    
    override func didMoveToView(view: SKView) {
        //背景の設定
        back.position = CGPoint(x: 0.0, y: 0.0)
        back.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.addChild(back)
        
        self.size = CGSize(width: 320, height: 568)
        
        //物理効果の設定
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        self.physicsWorld.contactDelegate = self
        
        //ゲームオーバ判定用
        makeBottom()
        
        //グレープの配置
        for pos in grapesPosition{
            makeGrape(pos)
        }
        
        //ボールを配置
        makeBall()
        
        //バーを配置
        makeBoard()
    }
    
    func makeBottom(){
        let bottom = SKShapeNode(rectOfSize: CGSize(width: self.size.width, height: 10))
        bottom.position = CGPoint(x: self.size.width*0.5, y: 10)
        let physicsBody = SKPhysicsBody(rectangleOfSize: bottom.frame.size)
        physicsBody.dynamic = false
        physicsBody.contactTestBitMask = 0x1 << 1
        bottom.physicsBody = physicsBody
        self.addChild(bottom)
        self.bottom = bottom
    }
    
    func makeGrape(position:(x:CGFloat,y:CGFloat)){
        var grape = Grape(imageNamed: "grape")
        grape.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed:"grape.png"), size: grape.size)
        grape.physicsBody?.affectedByGravity = false
        grape.physicsBody?.dynamic = false
        grape.physicsBody?.restitution = 1.0
        grape.physicsBody?.friction = 0.0
        grape.physicsBody?.linearDamping = 0.0
        grape.position = CGPoint(x:position.x,y:position.y)
        grapes.append(grape)
        self.addChild(grape)
    }
    
    func makeBall(){
        ball.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed:"ball"), size: ball.size)
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.restitution = 1.0
        ball.physicsBody?.friction = 0.0
        ball.physicsBody?.linearDamping = 0.0
        ball.physicsBody?.contactTestBitMask = 0x1 << 1
        ball.position = CGPoint(x:self.size.width / 2.0 - 100,y:self.size.height / 2.0 + 50)
        
        self.addChild(ball)
    }
    
    func startBall(){
        ball.physicsBody?.applyImpulse(CGVector(dx: 1, dy: -2))
    }
    
    func makeBoard(){
        board.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed:"board"), size: board.size)
        board.physicsBody?.dynamic = false
        board.physicsBody?.restitution = 1.0
        board.physicsBody?.friction = 0.0
        board.physicsBody?.linearDamping = 0.0
        board.position = CGPoint(x:self.size.width / 2.0,y:100.0)
        self.addChild(board)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch: AnyObject = touches.first {
            let location = touch.locationInNode(self)
            let action = SKAction.moveTo(CGPoint(x: location.x, y: 100), duration: 0.2)
            self.board.runAction(action)
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch: AnyObject = touches.first {
            if !isStarted{
                startBall()
                isStarted = true
            }
            
        }
    }
    
    
}

extension GameScene:SKPhysicsContactDelegate{
    func didBeginContact(contact: SKPhysicsContact) {
        
        if contact.bodyA.node == self.bottom || contact.bodyB.node == self.bottom {
            self.paused = true
            println("game over")
        }
        
        for (index,g) in enumerate(grapes){
            if contact.bodyA.node == g || contact.bodyB.node == g {
                g.hitCount++
                if g.hitCount > 4{
                    g.removeFromParent()
                    grapes.removeAtIndex(index)
                    
                    let particle = SKEmitterNode(fileNamed: "MyParticle.sks")
                    self.addChild(particle)
                    
                    let removeAction = SKAction.removeFromParent()
                    let durationAction = SKAction.waitForDuration(1)
                    let sequenceAction = SKAction.sequence([durationAction,removeAction])
                    particle.runAction(sequenceAction)
                    
                    particle.position = CGPoint(x: g.position.x, y: g.position.y)
                    particle.alpha = 1
                    
                }
                println("count:\(grapes.count)")
                if grapes.count == 0{
                    self.paused = true
                    println("success")
                    
                    let scene = GameScene()
                    scene.size = self.view!.frame.size
                    self.view?.presentScene(scene)
                }
            }
        }
    }
}


class Grape:SKSpriteNode {
    var hitCount:Int = 0
}
