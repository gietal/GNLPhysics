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
    var scene: SKScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scene = SKScene(size: skView.bounds.size)

        // Set the scene coordinates (0, 0) to the center of the screen.
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.delegate = self
        
        let camera = SKCameraNode()
        camera.position = CGPoint(x: 0, y: 0)
        camera.xScale = 1
        camera.yScale = 1
        camera.zRotation = 0
        camera.zPosition = 10
        
        
        
        border.fillColor = .clear
        border.strokeColor = .white
        border.lineWidth = 1
        
        scene.camera = camera
        scene.addChild(camera)
        scene.addChild(border)
        
        
//        addCircleGameObject(pos: Vec2(x: 150, y: 0), radius: 10)
//        addCircleGameObject(pos: Vec2(x: -150, y: 50), radius: 20)
        onAddCircleTimer()
        
        skView.presentScene(scene)
    }
    
    func onAddCircleTimer() {

        // add random
        let radius = CGFloat.random(in: 10...20)
        let maxPos = border.radius - radius
        let posRange = -Float(maxPos)...Float(maxPos)
        addCircleGameObject(pos: Vec2(x: Float.random(in: -100...100), y: Float.random(in: 50...100)), radius:radius)

        // reschedule
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.onAddCircleTimer()
        })
    }
    
    func addCircleGameObject(pos: Vec2, radius: CGFloat) -> GameObject {
        let circle = GameObject(shape: SKShapeNode(circleOfRadius: radius))
        circle.shape.fillColor = .red
        circle.shape.strokeColor = .white
        circle.body.setInitialPosition(pos)
        
        scene.addChild(circle.shape)
        gameObjects.append(circle)
        
        return circle
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
        
        
        let subdivision = 8
        
        let subDt = dt / Double(subdivision)
        for _ in 0..<subdivision {
            applyGravity()
            applyConstraints()
            resolveCollision()
            updatePositions(subDt)
        }
        
    }
    
    func applyGravity() {
        let gravityForce = Vec2(x: 0, y: -100) // assumes all object mass are the same = 1
        for obj in gameObjects {
            // add gravity
            obj.body.accumulatedForce += gravityForce
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
    
    func resolveCollision() {
        if gameObjects.count < 2 {
            return
        }
        
        // first gather the collision info, n^2
        var collisionInfo = [(IntersectionData, GameObject, GameObject)]()
        for i in 0..<gameObjects.count - 1 {
            for j in i+1..<gameObjects.count {
                let a = gameObjects[i]
                let b = gameObjects[j]
                
                let info = intersectCircleToCircle(aPos: a.body.position, aRadius: Float(a.shape.radius), bPos: b.body.position, bRadius: Float(b.shape.radius))
                if info.isIntersecting {
                    collisionInfo.append((info, a, b))
                }
            }
        }
        
        // now go thru all the colliding objects and push them away from each other
        for (info, a, b) in collisionInfo {
            let distanceToPush = info.intersectDistance / 2
            a.body.position += -info.normal * distanceToPush
            b.body.position += info.normal * distanceToPush
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

