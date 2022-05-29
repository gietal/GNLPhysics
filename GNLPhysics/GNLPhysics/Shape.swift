//
//  Shape.swift
//  GNLPhysics
//
//  Created by gietal on 5/29/22.
//

import Foundation


public struct Body {
    public var position = Vec2.zero
    public var velocity = Vec2.zero
    public var accumulatedForce = Vec2.zero
    
    public init() {
        
    }
}

public struct Circle {
    public var position = Vec2.zero
    public var radius: Float = 1
}
