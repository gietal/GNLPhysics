//
//  EulerIntegration.swift
//  GNLPhysics
//
//  Created by gietal on 5/29/22.
//

import Foundation

public class EulerIntegration {
    public init() {
        
    }
    
    public func update(dt: Float, body: inout Body) {
        // f = ma
        // a = f/m
        let mass: Float = 1 // assume 1 mass for now
        let acceleration = mass.isZero ? Vec2.zero : body.accumulatedForce / mass
        
        body.velocity += acceleration * dt
        body.position += body.velocity * dt
        
        body.accumulatedForce = .zero
    }
}
