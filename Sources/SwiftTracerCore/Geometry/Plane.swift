//
//  Plane.swift
//  SwiftTracer
//
//  Created by Hugo Tunius on 09/08/15.
//  Copyright © 2015 Hugo Tunius. All rights reserved.
//

import Foundation


class Plane {
    let position: Vector
    let normal: Vector
    let material: Material

    init(position: Vector, normal: Vector, material: Material) {
        self.position = position
        self.normal = normal
        self.material = material
    }
}

extension Plane : Shape {
    func intersectWithRay(ray: Ray) -> Intersection? {
        let denominator = normal.dot(ray.direction)
        if abs(denominator) < 1e-5 {
            return nil
        }

        let t = (position - ray.origin).dot(normal) / denominator

        if t >= 1e-5 {
            let intersectionPoint = ray.origin + ray.direction * t
            return Intersection(t: t, point: intersectionPoint, normal: normal, shape: self)
        }

        return nil
    }
}
