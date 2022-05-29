//
//  Vec2.swift
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
public func - (left: Vec2, right: Vec2) -> Vec2 {
    return Vec2(x: left.x - right.x, y: left.y - right.y)
}

public func += (left: inout Vec2, right: Vec2) {
    left = left + right
}

extension CGPoint {
    public init(_ vec2: Vec2) {
        self.init(x: CGFloat(vec2.x), y: CGFloat(vec2.y))
    }
}

