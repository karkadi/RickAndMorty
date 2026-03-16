//
//  AboutViewModel.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

import Observation

@MainActor
@Observable
public final class AboutViewModel {
    let aboutInfo: AboutInfo
    
    public init(aboutInfo: AboutInfo) {
        self.aboutInfo = aboutInfo
    }
}
