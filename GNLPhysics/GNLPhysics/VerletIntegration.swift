//
//  VerletIntegration.swift
//  GNLPhysics
//
//  Created by gietal on 5/29/22.
//

import Foundation

public struct VerletBody {
    public var position = Vec2.zero
    internal var oldPosition = Vec2.zero
    public var accumulatedForce = Vec2.zero
    
    internal var mass: Float = 1 // assume 1 mass for now
    
    public init() {
        
    }
    
    public mutating func setInitialPosition(_ pos: Vec2) {
        position = pos
        oldPosition = pos
    }
}


public class VerletIntegration {
    public init() {
        
    }
    public func update(dt: Float, body: inout VerletBody) {
        // f = ma
        // a = f/m
        let acceleration = body.mass.isZero ? Vec2.zero : body.accumulatedForce / body.mass
        
        // determine velocity from current and old position
        let velocity = body.position - body.oldPosition
        
        // save old position
        body.oldPosition = body.position
        
        // update new position
        body.position += velocity + acceleration * dt * dt // why dt2?
        
        // clear out force
        body.accumulatedForce = .zero
    }
}
