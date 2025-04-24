//
//  ViewModel.swift
//  Fetch Project
//
//  Created by Katherine Duncan-Welke on 4/12/25.
//

import Foundation
import SwiftUI

@Observable public class ViewModel {
    
    // caching
    var recipes: [Recipe] = []
    var smallImages: [String: UIImage] = [:]
    var largeImages: [String: UIImage] = [:]
    
    // variables
    var errorText = ""
    var noImage = false
    var searchText = ""
    var filter: Filtering = .any
    
    var searchResults: [Recipe] {
        // handle searching and filtering
        if searchText == "" {
            return filterRecipes(filter: filter)
        } else {
            return searchRecipes(searchTerms: searchText)
        }
    }
    
    func getRecipes() {
        // download recipes using task
        Task {
            do {
                try await fetchRecipes()
                errorText = ""
            } catch {
                errorText = error.localizedDescription
            }
        }
    }
    
    func fetchRecipes() async throws {
        // download data
        if let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") {
            guard let reply: (data: Data, response: URLResponse) = try? await URLSession.shared.data(from: url) else {
                throw RecipeErrors.noData
            }
            
            // handle non-200 HTTP response, indicating a network problem
            if let httpResponse = reply.response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    throw RecipeErrors.networkProblem
                }
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
            
            // some characters in the json have been sent decoded as Windows-1252, replace specific instance
            for index in (0..<loaded.recipes.count) {
                if loaded.recipes[index].name.contains("Å›") {
                    var correctedRecipe = loaded.recipes[index]
                    correctedRecipe.name = correctedRecipe.name.replacingOccurrences(of: "Å›", with: "ś")
                    loaded.recipes[index] = correctedRecipe
                }
            }
        
            // cache recipes
            recipes = loaded.recipes
        } else {
            // url was incorrect/invalid
            throw RecipeErrors.invalidLink
        }
    }
    
    func getURL(urlToUse: String?) -> URL? {
        // get URL from string
        if let stringURL = urlToUse, let url = URL(string: stringURL) {
            return url
        } else {
            return nil
        }
    }
    
    func getURLName(url: String?) -> String {
        // separate out domain from url to use as website name
        if let stringURL = url {
            let truncated = stringURL.components(separatedBy: ("/"))[2]
            return truncated
        } else {
            return "Unknown Website"
        }
    }

    func searchRecipes(searchTerms: String) -> [Recipe] {
        // accomodate searching within already applied filter
        let filtered = filterRecipes(filter: filter)
        
        // search by name or cusine type
        let results = filtered.filter { $0.name.contains(searchTerms) || $0.cuisine.contains(searchTerms) }
        return results
    }
    
    func filterRecipes(filter: Filtering) -> [Recipe] {
        // apply filters by link or video
        switch filter {
        case .any:
            return recipes
        case .withLink:
            return recipes.filter { $0.sourceUrl != nil }
        case .withVideo:
            return recipes.filter { $0.youtubeUrl != nil }
        case .withBoth:
            return recipes.filter { $0.sourceUrl != nil && $0.youtubeUrl != nil }
        }
    }
    
    func getImage(recipe: Recipe, size: ImageSize) {
        // download image using task
        Task {
            do {
                try await downloadImage(recipe: recipe, size: size)
                noImage = false
            } catch {
                noImage = true
            }
        }
    }
    
    func downloadImage(recipe: Recipe, size: ImageSize) async throws {
        var recipeURL: String?
        
        // handle size variations, if cached image is present do not redownload
        switch size {
        case .small:
            if let cached = smallImages[recipe.id] {
                return
            }
            
            recipeURL = recipe.photoUrlSmall
        case .large:
            if let cached = largeImages[recipe.id] {
                return
            }
            
            recipeURL = recipe.photoUrlLarge
        }
        
        // get data
        if let stringURL = recipeURL, let url = URL(string: stringURL) {
            guard let (data, _) = try? await URLSession.shared.data(from: url) else {
                throw RecipeErrors.noData
            }
            guard let image = UIImage(data: data) else {
                // cannot get image
                throw RecipeErrors.noData
            }
            
            // cache images in size-based dictionaries
            switch size {
            case .small:
                smallImages[recipe.id] = image
            case .large:
                largeImages[recipe.id] = image
            }
        } else {
            // url was likely invalid
            throw RecipeErrors.noData
        }
    }
}
