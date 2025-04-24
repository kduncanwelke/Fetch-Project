//
//  Errors.swift
//  Fetch Project
//
//  Created by Katherine Duncan-Welke on 4/17/25.
//

import Foundation

// used in networking to deliver error messages
enum RecipeErrors: LocalizedError {
    case invalidLink
    case noData
    case malformedData
    case networkProblem
    
    var errorDescription: String? {
        switch self {
        case .invalidLink:
            return "Could not retrieve data."
        case .noData:
            return "No recipe data available."
        case .malformedData:
            return "Recipes could not be parsed."
        case .networkProblem:
            return "Could not connect to server."
        }
    }
}
