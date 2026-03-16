//
//  MetalError.swift
//  MetalKitUI
//
//  Created by Arkadiy KAZAZYAN on 12/03/2026.
//

// Error type for Metal-specific failures
enum MetalError: Error {
    case initializationFailed
    case pipelineCreationFailed
    case bufferCreationFailed
}
