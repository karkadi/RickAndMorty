//
//  LikeView.swift
//  InstagramLikeApp
//
//  Created by Arkadiy KAZAZYAN on 07/10/2025.
//

import SwiftUI

struct LikeView: View {
    let isLiked: Bool
    @Binding var toggleLike: Bool
    @State private var animateHeart: Bool = false
    @State private var heartOffset: CGFloat = 0
    let action: () -> Void
    
    var body: some View {
        ZStack {
            if animateHeart {
                Image(systemName: "heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: heartOffset == 0 ? 30 : 50, height: heartOffset == 0 ? 30 : 50)
                    .foregroundStyle(.red)
                    .offset(y: heartOffset)
                    .zIndex(2)
                    .onAppear {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.5, blendDuration: 0.1)) {
                            heartOffset = -100
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                heartOffset = 0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                animateHeart = false
                            }
                        }
                    }
            }
            Button {
                triggerLikeWithAnimation()
            } label: {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(isLiked ? .red : .white)
                    .zIndex(1)
            }
            .padding(.horizontal, 30)
            .accessibilityLabel("Like")
        }
        .onChange(of: toggleLike) { _, _ in
            triggerLikeWithAnimation()
        }
    }
    
    private func triggerLikeWithAnimation() {
        guard animateHeart == false else { return }
        if isLiked {
            action()
        } else {
            animateHeart = true
            heartOffset = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                action()
            }
        }
    }
}
