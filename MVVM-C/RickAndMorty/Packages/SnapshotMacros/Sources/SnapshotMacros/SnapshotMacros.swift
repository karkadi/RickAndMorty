// SnapshotMacros.swift  (declaration — goes in your test helper module)

import Testing

/// Attaches an image to the current test report.
/// Expands to: Attachment.record(image, named: name)
@available(iOS 26.0, *)
@freestanding(expression)
public macro attach<T: AttachableAsImage>(
    _ image: T,
    named name: String? = nil
) = #externalMacro(module: "SnapshotMacroImpl", type: "AttachMacro")
