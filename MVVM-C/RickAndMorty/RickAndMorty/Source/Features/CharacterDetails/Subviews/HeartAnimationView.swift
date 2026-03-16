//
//  HeartAnimationView.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 07/03/2026.
//

import SwiftUI

// Separate heart animation view
struct HeartAnimationView: View {
    @State private var scale: CGFloat = 0.1
    @State private var opacity: CGFloat = 1
    @State private var offset: CGFloat = 0
    
    var body: some View {
        Image(systemName: "heart.fill")
            .font(.system(size: 80))
            .foregroundColor(.red)
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(y: offset)
            .onAppear {
                withAnimation(.easeOut(duration: 0.4)) {
                    scale = 1.2
                }
                
                withAnimation(.easeOut(duration: 0.8)) {
                    offset = -100
                    opacity = 0
                }
            }
    }
}
