//
//  Shape.swift
//  GNLPhysics
//
//  Created by gietal on 5/29/22.
//

import Foundation

public struct Vec2: Equatable {
    public var x: Float
    public var y: Float
    
    public static let zero = Vec2(x: 0, y: 0)
    
    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
}


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
