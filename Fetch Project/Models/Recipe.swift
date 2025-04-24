//
//  Recipe.swift
//  Fetch Project
//
//  Created by Katherine Duncan-Welke on 4/12/25.
//

import Foundation

struct Recipes: Codable {
    var recipes: [Recipe]
}

// recipe object, use UUID as identifier
struct Recipe: Codable, Identifiable, Hashable {
    var id: String { return uuid }
    
    var cuisine: String
    var name: String
    var photoUrlLarge: String?
    var photoUrlSmall: String?
    var uuid: String
    var sourceUrl: String?
    var youtubeUrl: String?
}
