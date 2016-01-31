SwiftTracer-Core
===========

OS independant ray tracing engine in Swift.

## Install

`SwiftTracer-Core` is a available as a pod and via SPM.

## Usage

Create a `Scene` and a ´Camera` and pass it to the `Renderer`.
Call `render` to start the rendering.

```swift
import SwiftTracer_Core

let refractiveMaterial = Material(color: Color(r: 1.0, g: 1.0, b: 1.0),
    ambientCoefficient: 0.0,
    diffuseCoefficient: 0.4,
    specularCoefficient: 0.4,
    reflectionCoefficient: 0.0,
    refractionCoefficient: 1.5)
let s = Sphere(radius: 0.5, center: Vector(x: -0.6, y: 0.6, z: 8.0), material: refractiveMaterial)

let camera = Camera(fov: 0.785398163, width: width, height: height)
self.renderer = Renderer(scene: Scene(objects: [s], lights: [], clearColor: Color.Black), camera: camera, maxDepth: 20)
self.renderer.delegate = self
self.renderer.render()
```

## Supports

+ Spheres
+ Planes
+ Point Lights
+ Super sampling
+ Refraction
+ Reflection

## License

MIT(See `LICENSE`)
