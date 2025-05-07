//
//  RecipeDetailViewModel.swift
//  testingApp
//
//  Created by Rama Adi Nugraha on 07/05/25.
//

import Observation
import Foundation



@Observable
class RecipeDetailViewModel {
    private let storageService: RecipeStorageService
    private let recipe: Recipe
    
    public var errorMessage: ErrorMessage?
    
    public var isFavorite = false
    
    init(storageService: RecipeStorageService, recipe: Recipe) {
        self.storageService = storageService
        self.recipe = recipe
    }
    
    func loadFavoriteStatus() async {
        do {
            let favorites = try await storageService.fetchFavoriteRecipes()
            if favorites.contains(where: { $0.id == recipe.id }) {
                isFavorite = true
            } else {
                isFavorite = false
            }
        } catch {
            self.errorMessage = ErrorMessage(message: "Failed to load favorite status")
        }
    }
    
    func toggleFavorite() async {
        do {
            if isFavorite {
                try await storageService.deleteFavoriteRecipe(recipe)
                self.isFavorite = false
            } else {
                try await storageService.saveFavoriteRecipe(recipe)
                self.isFavorite = true
            }
            
            await loadFavoriteStatus()
            
        } catch {
            self.errorMessage = ErrorMessage(message: "Failed to toggle favorite status")
        }
    }
}
