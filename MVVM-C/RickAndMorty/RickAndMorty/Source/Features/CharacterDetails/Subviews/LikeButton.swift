//
//  LikeButton.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 07/03/2026.
//

import SwiftUI

// Stable Like Button without animations that affect layout
struct LikeButton: View {
    let isLiked: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Background to maintain size
                Color.clear
                    .frame(width: 44, height: 44)
                
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(isLiked ? .red : .white)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 44, height: 44)
    }
}
