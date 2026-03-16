//
//  Uniforms.swift
//  MetalKitUI
//
//  Created by Arkadiy KAZAZYAN on 12/03/2026.
//

// Define the uniforms struct to match the shader
struct Uniforms {
    var time: Float              // 4 bytes
    var resolution: SIMD2<Float> // 8 bytes
    var mouse: SIMD2<Float>      // 8 bytes
    var mouseDown: Float         // 4 bytes
    var padding: Float           // 4 bytes (added to reach alignment/size consistency)
}
