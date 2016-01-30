//
//  Color.swift
//  SwiftTracer
//
//  Created by Hugo Tunius on 19/08/15.
//  Copyright © 2015 Hugo Tunius. All rights reserved.
//

import XCTest
@testable import SwiftTracerCore

class ColorTests: XCTestCase {
    let c = Color(r: UInt8(230), g: UInt8(190), b: UInt8(25))
    let a = Color(r: 1.2, g: 0.5, b: -0.5)

    func testInit() {
        XCTAssertEqual(c, Color(0xFF19BEE6))
    }

    func testDoubleInit() {
        XCTAssertEqual(a, 0xFF007FFF, "Init with double values should work and correctly clamp values")
    }

    func testProperties() {
        XCTAssertEqual(c.r, 230)
        XCTAssertEqual(c.g, 190)
        XCTAssertEqual(c.b, 25)

        XCTAssertEqual(a.r, 255)
        XCTAssertEqual(a.g, 127)
        XCTAssertEqual(a.b, 0)
    }
}
