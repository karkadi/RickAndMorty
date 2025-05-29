//
//  MetalRenderer.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 29/03/2025.
//

import MetalKit

class MetalRenderer: NSObject, MTKViewDelegate {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let pipelineState: MTLRenderPipelineState
    var mouse: SIMD2<Float> = [0, 0]
    var uniformsBuffer: MTLBuffer
    var time: Float = 0

    init?(mtkView: MTKView) {
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue(),
              let library = try? device.makeDefaultLibrary(bundle: .main)
        else { return nil }

        self.device = device
        self.commandQueue = commandQueue

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = library.makeFunction(name: "vertex_main")
        pipelineDescriptor.fragmentFunction = library.makeFunction(name: "fragmentFunction")
        pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat

        guard let pipelineState = try? device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        else { return nil }
        self.pipelineState = pipelineState

        // Initial uniforms
        var initialUniforms = Uniforms(
            time: 0.0,
            resolution: SIMD2<Float>(Float(mtkView.drawableSize.width), Float(mtkView.drawableSize.height)),
            mouse: SIMD2<Float>(0.0, 0.0),
            mouseDown: 0.0,
            padding: 0
        )
        guard let uniformsBuffer = device.makeBuffer(bytes: &initialUniforms,
                                                     length: MemoryLayout<Uniforms>.size,
                                                     options: .storageModeShared)
        else { return nil }

        self.uniformsBuffer = uniformsBuffer

        super.init()
        mtkView.device = device
        mtkView.delegate = self

        // Add gesture recognizer for mouse/touch input
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        mtkView.addGestureRecognizer(panGesture)
    }

    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: gesture.view)
        let uniforms = uniformsBuffer.contents().bindMemory(to: Uniforms.self, capacity: 1)

        uniforms[0].mouse = SIMD2<Float>(Float(location.x), Float(location.y))
        uniforms[0].mouseDown = (gesture.state == .began || gesture.state == .changed) ? 1.0 : 0.0
    }

    func mtkView(_: MTKView, drawableSizeWillChange size: CGSize) {
        let uniforms = uniformsBuffer.contents().bindMemory(to: Uniforms.self, capacity: 1)
        uniforms[0].resolution = SIMD2<Float>(Float(size.width), Float(size.height))
    }

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        else { return }

        // Update uniforms
        let uniforms = uniformsBuffer.contents().bindMemory(to: Uniforms.self, capacity: 1)
        uniforms[0].time = time// Float(-startTime.timeIntervalSinceNow)

        renderEncoder.setRenderPipelineState(pipelineState)

        // Set uniforms buffer
        renderEncoder.setFragmentBuffer(uniformsBuffer, offset: 0, index: 0)

        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)

        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
        time += 0.01
    }
}
