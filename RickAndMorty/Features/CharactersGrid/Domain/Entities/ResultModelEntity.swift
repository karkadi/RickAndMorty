//
//  ResultModelEntity.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import Foundation

// MARK: - Result
struct ResultModelEntity: Equatable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let image: String
    let created: String

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension ResultModelDTO {
    func toEntity() -> ResultModelEntity {
        // Date formatter for ISO 8601
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        // Convert string to Date, using current date as fallback
        let createdDate = dateFormatter.date(from: created) ?? Date()
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"

        return ResultModelEntity(id: id,
                                 name: name,
                                 status: status,
                                 species: species,
                                 type: type,
                                 gender: gender,
                                 image: image,
                                 created: dateFormatterPrint.string(from: createdDate))
    }
}
