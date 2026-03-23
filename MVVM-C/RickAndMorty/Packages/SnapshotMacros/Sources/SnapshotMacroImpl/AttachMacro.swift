//
//  AttachMacro.swift
//  SnapshotMacros
//
//  Created by Arkadiy KAZAZYAN on 23/03/2026.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AttachMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        // Extract arguments from #attach(...)
        guard let argumentList = LabeledExprListSyntax(node.arguments) else {
            throw MacroError.expectedArguments
        }
        
        // Find the image argument
        guard let imageArg = argumentList.first(where: { $0.label?.text == nil }) ?? argumentList.first else {
            throw MacroError.expectedImageArgument
        }
        
        // Find the named argument
        let namedArg = argumentList.first(where: { $0.label?.text == "named" })
        
        // Build the replacement expression: Attachment.record(image, named: "\(name)_expected")
        var expression = "Attachment.record(\(imageArg.expression)"
        
        if let namedArg = namedArg {
            expression += ", named: \(namedArg.expression)"
        }
        
        expression += ")"
        
        return ExprSyntax(stringLiteral: expression)
    }
}

enum MacroError: Error, CustomStringConvertible {
    case expectedArguments
    case expectedImageArgument
    
    var description: String {
        switch self {
        case .expectedArguments:
            return "#attach macro expects arguments"
        case .expectedImageArgument:
            return "#attach macro expects an image argument"
        }
    }
}

@main
struct AttachMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AttachMacro.self,
    ]
}
