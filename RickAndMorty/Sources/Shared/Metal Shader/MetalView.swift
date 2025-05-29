//
//  MetalView.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 29/03/2025.
//

import MetalKit
import SwiftUI

// SwiftUI View Representable for MTKView
struct MetalView: UIViewRepresentable {
    func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = false
        mtkView.isPaused = false
        mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
        context.coordinator.renderer = MetalRenderer(mtkView: mtkView)

        return mtkView
    }

    func updateUIView(_: MTKView, context _: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var renderer: MetalRenderer?
    }
}

#Preview{
    MetalView()
}
