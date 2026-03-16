//
//  AboutInfo.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

public struct AboutInfo: Sendable {
    let appName : String
    let creator : String
    let creationDate : String
    
    public init (appName: String =  "Rick & Morty",
                 creator: String = "Arkadiy KAZAZYAN",
                 creationDate: String = "2026") {
        self.appName = appName
        self.creator = creator
        self.creationDate = creationDate
    }
    
}
