//
//  ContentView.swift
//  Fetch Project
//
//  Created by Katherine Duncan-Welke on 4/12/25.
//

import SwiftUI

struct RecipeView: View {
    @State private var viewModel = ViewModel()
    
    let recipe: Recipe

    var body: some View {
        NavigationStack {
            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(recipe.name)
                            .font(.headline)
                        Text(recipe.cuisine)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    if viewModel.noImage {
                        Image("NoImage")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .cornerRadius(5)
                            .accessibilityIdentifier("Placeholder image")
                    } else if let recipeImage = viewModel.smallImages[recipe.id] {
                        Image(uiImage: recipeImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .cornerRadius(5)
                            .accessibilityIdentifier("Photo of \(recipe.name)")
                    } else {
                        ProgressView()
                    }
                }
                .task {
                    viewModel.getImage(recipe: recipe, size: .small)
                }
            }
            .padding(.trailing, -7)
        }
    }
}

struct ContentView: View {
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            if viewModel.errorText != "" {
                Text(viewModel.errorText)
                    .font(.subheadline)
            }
            List {
                ForEach(viewModel.searchResults) { recipe in
                    RecipeView(recipe: recipe)
                }
            }
            .task {
                viewModel.getRecipes()
            }
            .refreshable {
                viewModel.getRecipes()
            }
            .navigationTitle("Recipes")
            .navigationDestination(for: Recipe.self, destination: RecipeDetailView.init)
            .toolbar {
                ToolbarItem {
                    Menu("Filters", systemImage: "line.3.horizontal.decrease.circle") {
                        Picker("Filter", selection: $viewModel.filter) {
                            ForEach(Filtering.allCases) {
                                Text($0.title)
                            }
                        }
                    }
                }
            }
        }
        .searchPresentationToolbarBehavior(.avoidHidingContent)
        .searchable(text: $viewModel.searchText, prompt: "Type to search")
        .overlay {
            if viewModel.recipes.isEmpty {
                ContentUnavailableView(
                    "No recipes available.", systemImage: "magnifyingglass", description: Text("No recipes found.")
                )
            } else if viewModel.searchResults.isEmpty {
                ContentUnavailableView(
                    "No recipes available.", systemImage: "magnifyingglass", description: Text("No results for \(viewModel.searchText).")
                )
            }
        }
    }
}

#Preview {
    ContentView()
}

