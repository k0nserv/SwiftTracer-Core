//
//  PlaneTests.swift
//  SwiftTracer-Core
//
//  Created by Hugo Tunius on 30/01/16.
//  Copyright © 2016 Hugo Tunius. All rights reserved.
//

import XCTest
@testable import SwiftTracerCore

class PlaneTests: XCTestCase {
    let plane = Plane(position: Vector(x: 0, y: 0, z: 5),
                        normal: Vector(x:0, y:0, z: -1),
                      material: Material(ambientColor: Color.black * 0.4, diffuseColor: Color.black * 0.4, specularColor: Color.black, reflectionCoefficient: 0.0, refractionCoefficient: nil))

    func testMiss() {
        let ray = Ray(origin: Vector(x: 0.0, y: 0.0, z: 0.0),
                   direction: Vector(x: 0.0, y: 0.0, z: -1.0))
        let intersection = plane.intersect(ray: ray)
        XCTAssertNil(intersection)
    }

    func testHit() {
        let ray = Ray(origin: Vector(x: 0.0, y: 0.0, z: 0.0),
            direction: Vector(x: 0.0, y: 0.0, z: 1.0))

        let intersection = plane.intersect(ray: ray)

        XCTAssertNotNil(intersection)
        let i = intersection!

        XCTAssertEqualWithAccuracy(i.t, 5.0, accuracy: 0.0001)
        XCTAssertTrue(i.point.fuzzyEquals(Vector(x: 0.0, y: 0.0, z: 5.0)))
        XCTAssertTrue(i.normal.fuzzyEquals(Vector(x: 0.0, y: 0.0, z: -1.0)))
    }
}
