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
    let border = SKShapeNode(circleOfRadius: 200)
    
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
        circle.body.setInitialPosition(Vec2(x: 150, y: 0))
        gameObjects.append(circle)
        
        border.fillColor = .clear
        border.strokeColor = .white
        border.lineWidth = 1
        
        scene.camera = camera
        scene.addChild(camera)
        scene.addChild(circle.shape)
        scene.addChild(border)
        
        skView.presentScene(scene)
    }
    
    fileprivate var lastUpdateTime: TimeInterval = .zero
    fileprivate let integrator = VerletIntegration()
}

extension SKShapeNode {
    var radius: CGFloat {
        return (path?.boundingBox.width ?? 0.0) / 2.0
    }
}

extension ViewController: SKSceneDelegate {
    func update(_ currentTime: TimeInterval, for scene: SKScene) {
        if lastUpdateTime == .zero {
            lastUpdateTime = currentTime
            return
        }
        
        let dt = currentTime - lastUpdateTime
        
        lastUpdateTime = currentTime
        
        
        
        // should this logic be on the demo? or should it be on its own class 'PhysicsScene' maybe
        applyGravity()
        applyConstraints()
        updatePositions(dt)
    }
    
    func applyGravity() {
        let gravity = Vec2(x: 0, y: -100) // assumes all object mass are the same = 1
        for obj in gameObjects {
            // add gravity
            obj.body.accumulatedForce += gravity
        }
    }
    
    func applyConstraints() {
        // let's constraint it to the center of the screen, with radius of 300
        let origin = Vec2.zero
        let constraintRadius = border.radius
        
        for obj in gameObjects {
            // get distance from current position to the origin
            let displacement = obj.body.position - origin
            let distance = displacement.length()
            
            let maxDistance = constraintRadius - obj.shape.radius
            if CGFloat(distance) > maxDistance {
                // apply constraint along the normal vector
                let n = displacement / distance
                obj.body.position = origin + n * Float(maxDistance)
            }
            
        }
    }
    
    func updatePositions(_ dt: Double) {
        for obj in gameObjects {
            // update physics body position
            integrator.update(dt: Float(dt), body: &obj.body)
            
            // update graphics
            obj.shape.position = CGPoint(obj.body.position)
        }
    }
}

