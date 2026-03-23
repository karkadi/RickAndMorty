import SnapshotMacros
import Testing

/// Attaches an image to the current test.
///
/// This macro expands to `Attachment.record(image, named: "\(name)_expected")`.
///
/// Example:
/// ```swift
/// #attach(screenshot, named: "\(testName)_expected")
/// ```
@freestanding(expression)
macro attach(_ image: any AttachableAsImage, named: String) = #externalMacro(module: "AttachMacroPlugin", type: "AttachMacro")
