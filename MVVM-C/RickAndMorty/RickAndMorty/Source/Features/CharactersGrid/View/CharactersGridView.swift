//
//  CharactersGridView.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

import SwiftUI

struct CharactersGridView: View {
    @State var viewModel: CharactersGridViewModel
    @State private var columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var orientation = UIDevice.current.orientation
    @State private var showingRetryDialog = false
    @State private var pendingRetryAction: (() async -> Void)?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.characters) { character in
                    CharacterPreviewView(character: character)
                        .onTapGesture {
                            viewModel.navigateToDetails(character: character)
                        }
                        .onAppear {
                            if character.id == viewModel.characters.last?.id {
                                Task {
                                    await viewModel.loadMoreCharacters()
                                }
                            }
                        }
                }
                
                if viewModel.isLoadingMore {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Rick and Morty")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.navigateToAbout()
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            await viewModel.loadCharacters()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            withAnimation {
                orientation = UIDevice.current.orientation
                columns = orientation.isLandscape ?
                    [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())] :
                    [GridItem(.flexible()), GridItem(.flexible())]
            }
        }
        .overlay {
            if viewModel.isLoading && viewModel.characters.isEmpty {
                ProgressView("Loading characters...")
            }
        }
        .alert("Network Error", isPresented: $showingRetryDialog) {
            Button("Cancel", role: .cancel) {
                pendingRetryAction = nil
            }
            Button("Retry") {
                if let action = pendingRetryAction {
                    Task {
                        await action()
                        pendingRetryAction = nil
                    }
                }
            }
        } message: {
            if let error = viewModel.error {
                Text(error)
            } else {
                Text("An unknown error occurred. Please try again.")
            }
        }
        .onChange(of: viewModel.error) { _, newValue in
            if newValue != nil {
                showingRetryDialog = true
            } else {
                showingRetryDialog = false
                pendingRetryAction = nil
            }
        }
    }
}
