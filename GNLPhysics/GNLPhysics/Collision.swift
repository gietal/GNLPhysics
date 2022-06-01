//
//  Collision.swift
//  GNLPhysics
//
//  Created by gietal on 5/30/22.
//

import Foundation

public struct IntersectionData {
    public var isIntersecting: Bool = false
    public var normal: Vec2 = .zero // points from A to B
    public var location: Vec2 = .zero // furthest point in object A
    public var intersectDistance: Float = .zero
    
}


public func intersectCircleToCircle(aPos: Vec2, aRadius: Float, bPos: Vec2, bRadius: Float) -> IntersectionData {
    var output = IntersectionData()
    
    let aToB = bPos - aPos
    
    let distance = aToB.length()
    
    // if just touching it's not intersecting
    if distance >= aRadius + bRadius {
        return output
    }
    
    output.isIntersecting = true
    output.intersectDistance = aRadius + bRadius - distance
    output.normal = aToB / distance
    
    // location is furthest point in object A
    output.location = bPos - output.normal * bRadius
    
    return output
}
