//
//  SnapshotConfig.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 14/03/2026.
//

import UIKit
import SwiftUI
import Testing

// MARK: - Configuration

public enum SnapshotConfig {

    /// When true snapshots are recorded instead of validated
    public static var recordMode = true

    /// Allowed pixel difference (0–1)
    public static var tolerance: Float = 0.05
}

// MARK: - Device Presets

public enum SnapshotDevice {

    case iPhoneSE
    case iPhone15
    case iPad

    var size: CGSize {
        switch self {
        case .iPhoneSE: return CGSize(width: 375, height: 667)
        case .iPhone15: return CGSize(width: 390, height: 844)
        case .iPad: return CGSize(width: 1024, height: 1366)
        }
    }
}

// MARK: - Main Snapshot API

@MainActor
public func assertSnapshot<V: View>(
    _ view: V,
    named name: String,
    device: SnapshotDevice = .iPhone15,
    colorScheme: UIUserInterfaceStyle = .light
) async throws {

    UIView.setAnimationsEnabled(false)

    let image = await render(
        view: view,
        size: device.size,
        interfaceStyle: colorScheme
    )

    try compareSnapshot(image: image, name: name)
}

@MainActor
private func makeWindow(size: CGSize) -> UIWindow {

    let scene = UIApplication.shared
        .connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .first!

    let window = UIWindow(windowScene: scene)
    window.frame = CGRect(origin: .zero, size: size)

    return window
}

// MARK: - Rendering

@MainActor
func render<V: View>(
    view: V,
    size: CGSize,
    interfaceStyle: UIUserInterfaceStyle
) async -> UIImage {
    let controller = UIHostingController(rootView: view)
    controller.overrideUserInterfaceStyle = interfaceStyle
    controller.view.bounds = CGRect(origin: .zero, size: size)
    
    let window = makeWindow(size: size)
    window.rootViewController = controller
    window.makeKeyAndVisible()
    
    // Wait longer for image loading and rendering
    try? await Task.sleep(for: .milliseconds(2000))
    
    // Multiple layout passes
    for _ in 0..<3 {
        controller.view.layoutIfNeeded()
        await Task.yield()
        try? await Task.sleep(for: .milliseconds(50))
    }
    
    let format = UIGraphicsImageRendererFormat()
    format.scale = 3.0
    format.opaque = false
    
    let renderer = UIGraphicsImageRenderer(size: size, format: format)
    
    return renderer.image { _ in
        controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
    }
}

// MARK: - Snapshot Comparison
// Also add this to ensure your comparison function always uses the normalized size
private func compareSnapshot(image: UIImage, name: String) throws {
    let bundle = Bundle(for: SnapshotBundleToken.self)
    
    // Normalize the test image first
    let normalizedImage = normalizeImage(image, to: CGSize(width: 390, height: 844), scale: 3.0)
    
    guard let snapshotURL = bundle.url(
        forResource: name,
        withExtension: "png"
    ) else {
        if SnapshotConfig.recordMode {
            try saveSnapshot(image: normalizedImage, name: name)
            return
        }
        Issue.record(SnapshotError("Missing snapshot: \(name)"))
        return
    }
    
    guard
        let data = try? Data(contentsOf: snapshotURL),
        let reference = UIImage(data: data)
    else {
        Issue.record(SnapshotError("Invalid snapshot file"))
        return
    }
    
    // Always normalize reference to our standard size
    let normalizedReference = normalizeImage(reference, to: CGSize(width: 390, height: 844), scale: 3.0)
    
    if !imagesEqual(lhs: normalizedImage, rhs: normalizedReference) {
        if SnapshotConfig.recordMode {
            // Save the new reference
            try saveSnapshot(image: normalizedImage, name: name)
            return
        }
        try generateDiff(lhs: normalizedImage, rhs: normalizedReference, name: name)
        try saveSnapshot(image: normalizedImage, name: "\(name)_actual")
        try saveSnapshot(image: normalizedReference, name: "\(name)_expected")
        Issue.record(SnapshotError("Snapshot mismatch: \(name)"))
    }
}

// Helper function to normalize images
private func normalizeImage(_ image: UIImage, to size: CGSize, scale: CGFloat) -> UIImage {
    let format = UIGraphicsImageRendererFormat()
    format.scale = scale
    format.opaque = false
    
    let renderer = UIGraphicsImageRenderer(size: size, format: format)
    return renderer.image { _ in
        image.draw(in: CGRect(origin: .zero, size: size))
    }
}

// MARK: - Pixel Comparison
private func imagesEqual(lhs: UIImage, rhs: UIImage) -> Bool {
    guard let lhsCGImage = lhs.cgImage, let rhsCGImage = rhs.cgImage else { return false }
    
    // Create bitmap contexts for pixel comparison
    let width = Int(lhs.size.width * lhs.scale)
    let height = Int(lhs.size.height * lhs.scale)
    
    guard width == Int(rhs.size.width * rhs.scale),
          height == Int(rhs.size.height * rhs.scale) else {
        return false
    }
    
    // Create pixel buffers
    let lhsProvider = lhsCGImage.dataProvider
    let rhsProvider = rhsCGImage.dataProvider
    
    guard let lhsData = lhsProvider?.data,
          let rhsData = rhsProvider?.data,
          let lhsBytes = CFDataGetBytePtr(lhsData),
          let rhsBytes = CFDataGetBytePtr(rhsData) else {
        return false
    }
    
    // Compare pixels with tolerance
    let bytesPerPixel = 4 // RGBA
    let totalPixels = width * height
    var differentPixels = 0
    
    for i in 0..<totalPixels {
        let byteOffset = i * bytesPerPixel
        
        // Compare RGBA values with tolerance
        let rDiff = abs(Int(lhsBytes[byteOffset]) - Int(rhsBytes[byteOffset]))
        let gDiff = abs(Int(lhsBytes[byteOffset + 1]) - Int(rhsBytes[byteOffset + 1]))
        let bDiff = abs(Int(lhsBytes[byteOffset + 2]) - Int(rhsBytes[byteOffset + 2]))
        let aDiff = abs(Int(lhsBytes[byteOffset + 3]) - Int(rhsBytes[byteOffset + 3]))
        
        // If any channel differs by more than tolerance, count as different pixel
        let tolerance = Int(255 * SnapshotConfig.tolerance) // Convert to pixel value tolerance
        if rDiff > tolerance || gDiff > tolerance || bDiff > tolerance || aDiff > tolerance {
            differentPixels += 1
        }
    }
    
    let differentPercentage = Double(differentPixels) / Double(totalPixels)
    print("🔍 Pixel difference: \(String(format: "%.4f", differentPercentage * 100))%")
    
    return differentPercentage <= Double(SnapshotConfig.tolerance)
}

// MARK: - Diff Image

private func generateDiff(lhs: UIImage, rhs: UIImage, name: String) throws {
    let size = lhs.size
    let renderer = UIGraphicsImageRenderer(size: size)
    
    let diff = renderer.image { ctx in
        // Draw reference image as background
        rhs.draw(at: .zero)
        
        // Create a difference mask
        ctx.cgContext.setBlendMode(.normal)
        
        // Draw the actual image with difference blend mode to highlight changes
        ctx.cgContext.setAlpha(0.7)
        lhs.draw(at: .zero, blendMode: .difference, alpha: 0.8)
        
        // Add a semi-transparent red overlay on areas that differ significantly
        ctx.cgContext.setFillColor(UIColor.red.withAlphaComponent(0.3).cgColor)
        ctx.cgContext.setBlendMode(.multiply)
        ctx.cgContext.fill(CGRect(origin: .zero, size: size))
        
        // Add grid lines to help identify positioning issues
        ctx.cgContext.setStrokeColor(UIColor.white.withAlphaComponent(0.3).cgColor)
        ctx.cgContext.setLineWidth(0.5)
        
        // Draw vertical grid lines every 50 points
        for x in stride(from: 0, to: size.width, by: 50) {
            ctx.cgContext.move(to: CGPoint(x: x, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: x, y: size.height))
        }
        
        // Draw horizontal grid lines every 50 points
        for y in stride(from: 0, to: size.height, by: 50) {
            ctx.cgContext.move(to: CGPoint(x: 0, y: y))
            ctx.cgContext.addLine(to: CGPoint(x: size.width, y: y))
        }
        
        ctx.cgContext.strokePath()
    }
    
    try saveSnapshot(image: diff, name: "\(name)_diff")
    try saveSnapshot(image: lhs, name: "\(name)_actual")
    try saveSnapshot(image: rhs, name: "\(name)_expected")
}

// MARK: - Save Snapshot

// Also update your saveSnapshot function to ensure consistent sizing
private func saveSnapshot(image: UIImage, name: String) throws {
    // Define the expected size for all snapshots
    let expectedSize = CGSize(width: 390, height: 844) // iPhone 15 size
    
    // Ensure image is saved at correct size
    let format = UIGraphicsImageRendererFormat()
    format.scale = 3.0
    format.opaque = false
    
    let renderer = UIGraphicsImageRenderer(size: expectedSize, format: format)
    let standardizedImage = renderer.image { ctx in
        // If image is different size, scale it to fit
        if image.size != expectedSize {
            image.draw(in: CGRect(origin: .zero, size: expectedSize))
        } else {
            image.draw(at: .zero)
        }
    }
    
    guard let data = standardizedImage.pngData() else { return }
    
    // Save to a known location (not temporary directory)
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let snapshotFolder = documentsPath.appendingPathComponent("Snapshots")
    
    // Create folder if needed
    try? FileManager.default.createDirectory(at: snapshotFolder, withIntermediateDirectories: true)
    
    let url = snapshotFolder.appendingPathComponent("\(name).png")
    try data.write(to: url)
    
    print("✅ Snapshot saved to: \(url.path)")
    print("   - Size: \(standardizedImage.size), Scale: \(standardizedImage.scale)")
    print("   - Pixel dimensions: \(standardizedImage.size.width * standardizedImage.scale) x \(standardizedImage.size.height * standardizedImage.scale)")
}

// MARK: - Helpers

struct SnapshotError: Error, CustomStringConvertible {
    let description: String
    init(_ description: String) { self.description = description }
}

private final class SnapshotBundleToken {}
