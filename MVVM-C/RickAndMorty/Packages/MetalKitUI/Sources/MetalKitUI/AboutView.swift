//
//  AboutView.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

import SwiftUI

public struct AboutView: View {
    @State var viewModel: AboutViewModel
    
    public init(viewModel: AboutViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            MetalView(fragmentFunction: "fragment_main_matrix")
            
            VStack(spacing: 16) {
                Spacer()
                
                VStack(spacing: 28) {
                    Text(viewModel.aboutInfo.appName)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(viewModel.aboutInfo.creator)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(viewModel.aboutInfo.creationDate)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
        }
        .background(Color.black)
        .transition(.opacity)
        .ignoresSafeArea(.all)
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AboutView(viewModel: .init(aboutInfo: .init()))
}
