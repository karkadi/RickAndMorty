//
//  DateFormattingTests.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 07/03/2026.
//

import Testing
@testable import RickAndMorty
import Foundation

// MARK: - Date Formatting Tests
struct DateFormattingTests {
    
    @Test("Date formatting works correctly with ISO8601 string")
    func testDateFormatting() {
        let dateString = "2017-11-04T22:34:53.659Z"
        
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        outputFormatter.timeStyle = .short
        
        if let date = inputFormatter.date(from: dateString) {
            let formattedDate = outputFormatter.string(from: date)
            #expect(formattedDate.contains("2017"))
            #expect(formattedDate.contains("Nov"))
        } else {
            #expect(Bool(false), "Failed to parse date")
        }
    }
    
    @Test("Date formatter handles invalid strings gracefully")
    func testInvalidDateFormatting() {
        let invalidDateString = "invalid-date"
        
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let date = inputFormatter.date(from: invalidDateString)
        #expect(date == nil)
    }
}
