//
//  EulerIntegration.swift
//  GNLPhysics
//
//  Created by gietal on 5/29/22.
//

import Foundation

public func / (scalar: Float, vec: Vec2) -> Vec2 {
    return Vec2(x: scalar / vec.x, y: scalar / vec.y)
}
public func / (vec: Vec2, scalar: Float) -> Vec2 {
    return Vec2(x: vec.x / scalar, y: vec.y / scalar)
}
public func * (vec: Vec2, scalar: Float) -> Vec2 {
    return Vec2(x: vec.x * scalar, y: vec.y * scalar)
}
public func + (left: Vec2, right: Vec2) -> Vec2 {
    return Vec2(x: left.x + right.x, y: left.y + right.y)
}

public func += (left: inout Vec2, right: Vec2) {
    left = left + right
}

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
