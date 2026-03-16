//
//  CharacterState.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 14/03/2025.
//

import Foundation
import OSLog
import SQLiteData

@Table
struct CharacterState: Identifiable {
    let id: Int
    var isSeen: Bool
    var isLiked: Bool
}

extension DependencyValues {
    mutating func bootstrapDatabase() throws {
        @Dependency(\.context) var context
        let database = try SQLiteData.defaultDatabase()
        kLogger.debug(
      """
      App database
      open "\(database.path)"
      """
        )

        var migrator = DatabaseMigrator()
#if DEBUG
        migrator.eraseDatabaseOnSchemaChange = true
#endif
        migrator.registerMigration("Create tables") { sqlDb in
            try #sql(
        """
        CREATE TABLE "characterStates" (
          "id" TEXT PRIMARY KEY NOT NULL ON CONFLICT REPLACE DEFAULT (uuid()),
          "isSeen" INTEGER NOT NULL ON CONFLICT REPLACE DEFAULT 0,
          "isLiked" INTEGER NOT NULL ON CONFLICT REPLACE DEFAULT 0
        ) STRICT
        """
            )
            .execute(sqlDb)
        }
        try migrator.migrate(database)
        defaultDatabase = database
    }
}

private let kLogger = Logger(subsystem: "SQLStoryState", category: "Database")
