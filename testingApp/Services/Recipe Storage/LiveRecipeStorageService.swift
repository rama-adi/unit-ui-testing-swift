//
//  LiveRecipeStorageService.swift
//  testingApp
//
//  Created by Rama Adi Nugraha on 07/05/25.
//
import Foundation

struct LiveRecipeStorageService: RecipeStorageService {
    private let fileManager = FileManager.default
    private let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private let fileName = "favorite_recipes.json"
    
    private var fileURL: URL {
        documentsPath.appendingPathComponent(fileName)
    }
    
    func saveFavoriteRecipe(_ recipe: Recipe) async throws {
        var recipes = try await fetchFavoriteRecipes()
        recipes.append(recipe)
        
        let data = try JSONEncoder().encode(recipes)
        try data.write(to: fileURL)
    }
    
    func fetchFavoriteRecipes() async throws -> [Recipe] {
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return []
        }
        
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([Recipe].self, from: data)
    }
    
    func deleteFavoriteRecipe(_ recipe: Recipe) async throws {
        var recipes = try await fetchFavoriteRecipes()
        recipes.removeAll { $0.id == recipe.id }
        
        let data = try JSONEncoder().encode(recipes)
        try data.write(to: fileURL)
    }
}
