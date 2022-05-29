//
//  ViewController.swift
//  Demo
//
//  Created by gietal on 5/29/22.
//

import Cocoa
import SpriteKit
import GNLPhysics

class GameObject {
    var body: VerletBody = VerletBody()
    var shape: SKShapeNode
    
    init(shape: SKShapeNode) {
        self.shape = shape
    }
}

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    var gameObjects = [GameObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let scene = SKScene(size: skView.bounds.size)

        // Set the scene coordinates (0, 0) to the center of the screen.
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.delegate = self
        
        let camera = SKCameraNode()
        camera.position = CGPoint(x: 0, y: 0)
        camera.xScale = 1
        camera.yScale = 1
        camera.zRotation = 0
        camera.zPosition = 10
        
        let circle = GameObject(shape: SKShapeNode(circleOfRadius: 10))
        circle.shape.fillColor = NSColor.red
        gameObjects.append(circle)
        
        scene.camera = camera
        scene.addChild(camera)
        scene.addChild(circle.shape)
        
        skView.presentScene(scene)
    }
    
    fileprivate var lastUpdateTime: TimeInterval = .zero
    fileprivate let integrator = VerletIntegration()
}


extension ViewController: SKSceneDelegate {
    func update(_ currentTime: TimeInterval, for scene: SKScene) {
        if lastUpdateTime == .zero {
            lastUpdateTime = currentTime
            return
        }
        
        let dt = currentTime - lastUpdateTime
        
        lastUpdateTime = currentTime
        
        let gravity = Vec2(x: 0, y: -100) // assumes all object mass are the same = 1
        
        for obj in gameObjects {
            // add gravity
            obj.body.accumulatedForce += gravity
            integrator.update(dt: Float(dt), body: &obj.body)
            
            // reset
            if obj.body.position.y < -300 {
                obj.body.position.y = 300
            }
            
            // update graphics
            obj.shape.position = CGPoint(obj.body.position)
        }
    }
}

