//
//  SphereTest.swift
//  SwiftTracer
//
//  Created by Hugo Tunius on 09/08/15.
//  Copyright © 2015 Hugo Tunius. All rights reserved.
//

import XCTest
@testable import SwiftTracerCore

class SphereTests: XCTestCase {
    let sphere = Sphere(
        radius: 2.0,
        center: Vector(x: 0.0, y: 0.0, z: 0.0),
        material: Material(ambientColor: Color.black, diffuseColor: Color.black)
    )

    func testMiss() {
        let ray = Ray(origin: Vector(x: 0.0, y: 0.0, z: -5.0), direction: Vector(x: 1.0, y: 0.0, z: 0.0))

        let intersection = sphere.intersect(ray: ray)
        XCTAssertNil(intersection)
    }

    func testHit() {
        let ray = Ray(origin: Vector(x: 0.0, y: 0.0, z: -5.0), direction: Vector(x: 0.0, y: 0.0, z: 1.0))
        let intersection = sphere.intersect(ray: ray)

        XCTAssertNotNil(intersection)
        let i = intersection!
        XCTAssertEqualWithAccuracy(i.t, 3.0, accuracy: 0.0001)
        XCTAssertTrue(i.point.fuzzyEquals(Vector(x: 0.0, y: 0.0, z: -2.0)))
        XCTAssertTrue(i.normal.fuzzyEquals(Vector(x: 0.0, y: 0.0, z: -1.0)))
        XCTAssertFalse(i.inside)
    }

    func testHitFromInside() {
        let ray = Ray(origin: Vector(x: 0.0, y: 0.0, z: 0.0), direction: Vector(x: 0.0, y: 0.0, z: 1.0))
        let intersection = sphere.intersect(ray: ray)

        XCTAssertNotNil(intersection)
        let i = intersection!
        XCTAssertEqualWithAccuracy(i.t, 2.0, accuracy: 0.0001)
        XCTAssertTrue(i.point.fuzzyEquals(Vector(x: 0.0, y: 0.0, z: 2.0)))
        XCTAssertTrue(i.normal.fuzzyEquals(Vector(x: 0.0, y: 0.0, z: 1.0)))
        XCTAssertTrue(i.inside)
    }
}

