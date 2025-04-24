//
//  Filtering.swift
//  Fetch Project
//
//  Created by Katherine Duncan-Welke on 4/21/25.
//

import Foundation

// use for filtering recipes
enum Filtering: String, Identifiable, Hashable, CaseIterable {
    case any
    case withLink
    case withVideo
    case withBoth
    var id: Self { return self }
    
    var title: String {
        switch self {
        case .any:
            return "Show All"
        case .withLink:
            return "Recipes with links"
        case .withVideo:
            return "Recipes with videos"
        case .withBoth:
            return "Recipes with links & videos"
        }
    }
}
