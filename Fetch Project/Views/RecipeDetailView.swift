//
//  RecipeDetailView.swift
//  Fetch Project
//
//  Created by Katherine Duncan-Welke on 4/16/25.
//

import SwiftUI
import AVKit
import WebKit

struct RecipeDetailView: View {
    @State private var viewModel = ViewModel()
    
    let recipe: Recipe
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if viewModel.noImage {
                        Image("NoImage")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(5)
                            .accessibilityIdentifier("Placeholder image")
                    } else if let recipeImage = viewModel.largeImages[recipe.id] {
                        Image(uiImage: recipeImage)
                            .resizable()
                            .scaledToFit()
                            .containerRelativeFrame(.horizontal) { size, axis in
                                size * 0.9
                            }
                            .cornerRadius(160)
                            .padding(.top, 7)
                            .frame(maxWidth: .infinity)
                            .accessibilityIdentifier("Photo of \(recipe.name)")
                    } else {
                        ProgressView()
                    }
                    Text("The \(recipe.cuisine) cuisine of \(recipe.name)")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, -10)
                    Divider()
                        .padding(.top, -15)
                    Text("Relevant Links")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .padding(.top, -20)
                        .padding(.bottom, 7)
                    Text("Recipe for \(recipe.name)")
                        .padding(.top, -10)
                    if let recipeLink = viewModel.getURL(urlToUse: recipe.sourceUrl) {
                        Button("Visit " + viewModel.getURLName(url: recipe.sourceUrl)) {
                            UIApplication.shared.open(recipeLink)
                        }
                        .buttonStyle(.bordered)
                        .padding(.top, -7)
                        .padding(.bottom, 10)
                    } else {
                        Text("No link available")
                            .foregroundStyle(.secondary)
                            .italic()
                            .padding(.top, -10)
                            .padding(.bottom, 10)
                    }
                    Text("Watch Recipe on YouTube")
                        .padding(.top, -10)
                    if let youtubeLink = viewModel.getURL(urlToUse: recipe.youtubeUrl) {
                        Button("Open Video in Browser") {
                            UIApplication.shared.open(youtubeLink)
                        }
                        .buttonStyle(.bordered)
                        .padding(.top, -7)
                        .padding(.bottom, 15)
                    } else {
                        Text("No video available")
                            .foregroundStyle(.secondary)
                            .italic()
                            .padding(.top, -10)
                            .padding(.bottom, 10)
                    }
                }
                .listRowSeparator(.hidden)
            }
            .task {
                viewModel.getImage(recipe: recipe, size: .large)
            }
            .navigationTitle(recipe.name)
        }
    }
}

#Preview {
    RecipeDetailView(recipe: Recipe(cuisine: "Malaysian", name: "Apam Balik", photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg", photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg", uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",   sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ", youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg"))
}
