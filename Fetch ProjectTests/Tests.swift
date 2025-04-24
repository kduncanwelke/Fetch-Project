//
//  Tests.swift
//  Fetch ProjectTests
//
//  Created by Katherine Duncan-Welke on 4/22/25.
//

import Testing
import Foundation
@testable import Fetch_Project

struct Tests {
    
    private let viewModel = ViewModel()
    let recipeStub = Recipe(cuisine: "Malaysian", name: "Apam Balik", photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg", photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg", uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8", sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ", youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg")
    
    @Test func testConnection() async throws {
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
        let reply: (data: Data, response: URLResponse) = try await URLSession.shared.data(from: url)
        
        // test for 200 response
        if let httpResponse = reply.response as? HTTPURLResponse {
            #expect(httpResponse.statusCode == 200, "Expected 200 status code")
        }
    }
    
    @Test func testMalformedData() async throws {
        await #expect(throws: RecipeErrors.malformedData) {
            if let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json") {
                guard let (data, _) = try? await URLSession.shared.data(from: url) else {
                    throw RecipeErrors.noData
                }
                
                // decode data
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard var loaded = try? decoder.decode(Recipes.self, from: data) else {
                    throw RecipeErrors.malformedData
                }
            }
        }
    }
    
    @Test func testEmptyData() async throws {
        await #expect(throws: RecipeErrors.noData) {
            if let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json") {
                guard let reply: (data: Data, response: URLResponse) = try? await URLSession.shared.data(from: url) else {
                    throw RecipeErrors.noData
                }
                
                // decode JSON
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard var loaded = try? decoder.decode(Recipes.self, from: reply.data) else {
                    throw RecipeErrors.malformedData
                }
                
                if loaded.recipes.isEmpty {
                    throw RecipeErrors.noData
                }
            }
        }
    }
    
    @Test func testJSONParsing() async throws {
        if let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") {
            guard let (data, _) = try? await URLSession.shared.data(from: url) else {
                throw RecipeErrors.noData
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard var loaded = try? decoder.decode(Recipes.self, from: data) else {
                throw RecipeErrors.malformedData
            }
            
            #expect(loaded.recipes.isEmpty == false, "Expected parsed JSON data")
        }
    }
    
    @Test func testRecipeDownload() async throws {
        try await viewModel.fetchRecipes()
        #expect(viewModel.recipes.isEmpty == false, "Expected recipe data")
    }
    
    @Test func testRecipeSmallImageDownload() async throws {
        try await viewModel.downloadImage(recipe: recipeStub, size: .small)
        #expect(viewModel.smallImages[recipeStub.id] != nil, "Expected non-nil image")
    }
    
    @Test func testRecipeLargeImageDownload() async throws {
        try await viewModel.downloadImage(recipe: recipeStub, size: .large)
        #expect(viewModel.largeImages[recipeStub.id] != nil, "Expected non-nil image")
    }
}
