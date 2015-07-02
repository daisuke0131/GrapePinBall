//
//  GameViewController.swift
//  GrapePinBall
//
//  Created by daisuke on 2015/07/02.
//  Copyright (c) 2015年 daisuke. All rights reserved.
//
import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene()
        let view = self.view as! SKView
        view.showsFPS = true
        view.showsNodeCount = true
        scene.size = view.frame.size
        view.presentScene(scene)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
