//
//  Material.swift
//  SwiftTracer
//
//  Created by Hugo Tunius on 09/08/15.
//  Copyright © 2015 Hugo Tunius. All rights reserved.
//

public class Material {
    public var ambientColor: Color = Color.black
    public var diffuseColor: Color = Color.black
    public var specularColor: Color = Color.black

    public var reflectionCoefficient: Double = 0.0
    public var isReflective: Bool {
        get {
            return reflectionCoefficient > 0.0
        }
    }

    public var refractionCoefficient: Double?

    public convenience init(ambientColor: Color, diffuseColor: Color) {
        self.init(ambientColor: ambientColor,
                  diffuseColor: diffuseColor,
                  specularColor: Color.black,
                  reflectionCoefficient: 0.0,
                  refractionCoefficient: nil)
    }

    public init(ambientColor: Color, diffuseColor: Color, specularColor: Color, reflectionCoefficient: Double, refractionCoefficient: Double?) {
        self.ambientColor = ambientColor
        self.diffuseColor = diffuseColor
        self.specularColor = specularColor
        self.reflectionCoefficient = reflectionCoefficient
        self.refractionCoefficient = refractionCoefficient
    }

    public func copy() -> Material {
        return Material(ambientColor: ambientColor,
                        diffuseColor: diffuseColor, 
                        specularColor: specularColor, 
                        reflectionCoefficient: reflectionCoefficient, 
                        refractionCoefficient: refractionCoefficient)
    }
}
