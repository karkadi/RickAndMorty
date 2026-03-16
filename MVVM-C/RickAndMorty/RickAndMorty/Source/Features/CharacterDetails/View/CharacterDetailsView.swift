//
//  CharacterDetailsView.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

import SwiftUI

struct CharacterDetailsView: View {
    @State var viewModel: CharacterDetailsViewModel
    @State private var scale: CGFloat = 0.8
    @State private var likedTrigger = false
    @Environment(\.dismiss) private var dismiss
    
    init(character: Character) {
        self._viewModel = State(initialValue: CharacterDetailsViewModel(character: character))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                // Character Image with overlay
                ZStack {
                    AsyncCharacterImage(image: viewModel.image)
                        .frame(width: 350, height: 350)
                        .scaleEffect(scale)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    // Heart animation overlay
                    if likedTrigger {
                        HeartAnimationView()
                    }
                }
                .frame(width: 350, height: 350)
                .onTapGesture(count: 2) {
                    triggerLikeAnimation()
                }
                
                // Like Button Row with fixed height
                HStack {
                    LikeButton(
                        isLiked: viewModel.character.isLiked,
                        action: {
                            Task {
                                await viewModel.toggleLike()
                            }
                        }
                    )
                    Spacer()
                }
                .padding(.horizontal)
                .frame(height: 50) // Fixed height prevents layout shifts
                
                // Character Details
                detailsSection
            }
            .padding(.vertical)
        }
        .navigationTitle(viewModel.character.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
                await viewModel.onAppear()
                startImageAnimation()
            }
    }
    
    private var detailsSection: some View {
        VStack(spacing: 12) {
            DetailRow(title: "Status:", value: viewModel.character.status)
            DetailRow(title: "Species:", value: viewModel.character.species)
            DetailRow(title: "Type:", value: viewModel.character.type.isEmpty ? "Unknown" : viewModel.character.type)
            DetailRow(title: "Gender:", value: viewModel.character.gender)
            DetailRow(title: "Created:", value: formatDate(viewModel.character.created))
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private func triggerLikeAnimation() {
        likedTrigger = true
        
        // Auto-hide animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            likedTrigger = false
        }
        
        // Toggle like
        Task {
            await viewModel.toggleLike()
        }
    }
    
    private func startImageAnimation() {
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 100_000_000)
            withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100, damping: 10)) {
                scale = 1.0
            }
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        outputFormatter.timeStyle = .short
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        return dateString
    }
}

#Preview {
    guard let character = MockData.mockedCharacters?.results.first?.toCharacter() else {
        return Text("No data available")
    }
    return CharacterDetailsView(character: character)
        .preferredColorScheme(.dark)
}
