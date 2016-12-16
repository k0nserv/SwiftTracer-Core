//
//  Renderer.swift
//  SwiftTracer
//
//  Created by Hugo Tunius on 09/08/15.
//  Copyright © 2015 Hugo Tunius. All rights reserved.
//

import Foundation

#if os(Linux)
  import Glibc
#else
  import Darwin.C
#endif

public protocol RendererDelegate {
    func didFinishRendering(pixels: [Color], duration: TimeInterval)
}

public enum SuperSampling {
    case off
    // Number of samples per dimensions
    // Example: On(4) is 4x4, 4 samples for x and 4 for y
    case on(UInt)
}

public struct Renderer {
    private static let epsilon: Double = 1e-12
    public let scene: Scene
    public let maxDepth: Int
    public var camera: Camera
    public var pixels: [Color]
    public var delegate: RendererDelegate?
    public var superSampling: SuperSampling {
        didSet {
            switch superSampling {
            case .off:
                samplesPerPixel = 1
            case .on(let samplesPerPixel):
                self.samplesPerPixel = samplesPerPixel
            }
        }
    }
    private var startTime: Date = Date()
    private var samplesPerPixel: UInt
    private var isRendering = false

    public init(scene: Scene, camera: Camera, maxDepth: Int) {
        self.scene = scene
        self.camera = camera
        self.pixels = []
        self.maxDepth = maxDepth
        self.superSampling = .off
        self.samplesPerPixel = 1
    }

    public mutating func render() {
        isRendering = true
        var result: [Color] = Array(repeating: scene.clearColor, count: camera.width * camera.height)
        startTime = Date()


        for y in 0..<camera.height {
            for x in 0..<camera.width {
                if !isRendering {
                    return
                }

                var colors: [Color] = Array(repeating: scene.clearColor, count: Int(samplesPerPixel*samplesPerPixel))
                for xSample in 0..<samplesPerPixel {
                    for ySample in 0..<samplesPerPixel {
                        let ray = camera.createRay(x: x, y: y, xSample: xSample, ySample: ySample, samplesPerPixel: samplesPerPixel)
                        colors[Int(ySample * samplesPerPixel + xSample)] = trace(ray: ray, depth: maxDepth)
                    }
                }

                let index = (camera.height - 1 - y) * camera.width + x
                if index > result.count {
                    // HACK: When isRendering is turned off in another
                    // thread the next line might still cause an index out of bounds
                    // error. This fixes the problem slightly, but it's a
                    // horrible solution.
                    // TODO: Think of a better way to deal with interupting rendering
                    // midway and doing rendering in the background
                    return
                }
                var avgR = 0.0
                var avgG = 0.0
                var avgB = 0.0

                for c in colors {
                    avgR += c.rd
                    avgG += c.gd
                    avgB += c.bd
                }

                result[index] = Color(r: avgR / Double(colors.count),
                                      g: avgG / Double(colors.count),
                                      b: avgB / Double(colors.count))
            }
        }

        pixels = result

        if let d = delegate {
            let duration = Date().timeIntervalSince(startTime)
            d.didFinishRendering(pixels: pixels, duration: duration)
        }
        isRendering = false
    }

    public mutating func abortRendering() {
        isRendering = false
    }

    private mutating func trace(ray: Ray, depth: Int) -> Color {
        if depth == 0 {
            return Color.black
        }

        var result = scene.clearColor
        let closestHit = scene.intersect(ray: ray)

        if let hit = closestHit {
            result = shade(atIntersection: hit, originalRay: ray)
            if hit.shape.material.isReflective {
                result = result + calculateReflection(atIntersection: hit, originalRay: ray, currentDepth: depth)
            }

            if let refractionCoefficient = hit.shape.material.refractionCoefficient {
                result = result + calculateRefraction(atIntersection: hit,refractionCoefficient:  refractionCoefficient, originalRay: ray, currentDepth: depth)
            }
        }


        return result
    }

    private func shade(atIntersection intersection: Intersection, originalRay: Ray) -> Color {
        let material = intersection.shape.material
        var result = material.ambientColor

        for light in scene.lights {
            var inShadow = false
            let distanceToLight = (intersection.point - light.position).length()
            let lightDirection = (light.position - intersection.point).normalize()
            let ray = Ray(origin: intersection.point + lightDirection * Renderer.epsilon,
                       direction: lightDirection)

            for object in scene.objects {
                if let hit = object.intersect(ray: ray) , hit.t < distanceToLight {
                    inShadow = true
                    break
                }
            }

            let lightColor = light.color * light.intensity
            var dot = lightDirection.dot(intersection.normal)
            if dot > 0 && !inShadow {
                result = result + (lightColor * material.diffuseColor) * dot
            }

            dot = originalRay.direction.dot(lightDirection.reflect(intersection.normal))
            if dot > 0 && !inShadow {
                let spec = pow(dot, 20)
                result = result + (lightColor * material.specularColor) * spec
            }
        }
        return result
    }

    private mutating func calculateReflection(atIntersection hit: Intersection, originalRay: Ray, currentDepth: Int) -> Color {
        let newDirection = originalRay.direction.reflect(hit.normal).normalize()
        let newRay = Ray(origin: hit.point + hit.point * newDirection * Renderer.epsilon,
            direction: newDirection)
        let reflectiveColor = trace(ray: newRay, depth: currentDepth - 1)
        return reflectiveColor * hit.shape.material.reflectionCoefficient
    }

    private mutating func calculateRefraction(atIntersection hit: Intersection, refractionCoefficient: Double, originalRay: Ray, currentDepth: Int) -> Color {
        var rCoeff = refractionCoefficient
        if hit.inside { // Leaving refractive material
            rCoeff = 1.0
        }
        let n = originalRay.mediumRefractionIndex / rCoeff
        var N = hit.normal
        if hit.inside {
            N = -N
        }
        let cosI = (N.dot(originalRay.direction))
        let c2 = 1.0 - n * n * (1.0 - cosI * cosI)
        if c2 > 0.0 {
            let T = (originalRay.direction * n + N * (n * cosI - sqrt(c2))).normalize()
            let newRay = Ray(origin: hit.point + hit.point * T * Renderer.epsilon,
                direction: T,
                mediumRefractionIndex: rCoeff)
            let refractionColor = trace(ray: newRay, depth: currentDepth - 1)
            let absorbance = hit.shape.material.ambientColor * 0.15 * -hit.t
            let transparency = Color(r: exp(absorbance.rd), g: exp(absorbance.gd), b: exp(absorbance.bd))
            return refractionColor * transparency
        }

        return Color.black
    }
}
