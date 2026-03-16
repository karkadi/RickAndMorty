//
//  MetalView.swift
//  MetalKitUI
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//
import MetalKit
import SwiftUI

public struct MetalView: UIViewRepresentable {
    let renderingClient: MetalRenderingClient
    
    public init?(fragmentFunction: String) {
        if let renderingUseCase = try? MetalRenderingClient(
            mtkView: MTKView(),
            fragmentFunction: fragmentFunction) {
            self.renderingClient = renderingUseCase
        } else {
            return nil
        }
    }

    public func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = false
        mtkView.isPaused = false

        do {
            try renderingClient.configure(mtkView: mtkView)
        } catch {
            print("Failed to configure MetalView: \(error)")
        }

        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan))
        mtkView.addGestureRecognizer(panGesture)

        return mtkView
    }

    public func updateUIView(_: MTKView, context _: Context) {
        // No updates needed for now
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(renderingUseCase: renderingClient)
    }

    @MainActor
    public class Coordinator {
        private let renderingUseCase: MetalRenderingClient

        init(renderingUseCase: MetalRenderingClient) {
            self.renderingUseCase = renderingUseCase
        }

        @objc func handlePan(gesture: UIPanGestureRecognizer) {
            let location = gesture.location(in: gesture.view)
            let isDown = (gesture.state == .began || gesture.state == .changed)
            renderingUseCase.updateMouse(location: location, isDown: isDown)
        }
    }
}

#Preview {
    MetalView(fragmentFunction: "fragment_main_matrix")
}
