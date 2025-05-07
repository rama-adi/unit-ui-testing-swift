//
//  FavoriteRecipeViewModel.swift
//  testingApp
//
//  Created by Rama Adi Nugraha on 08/05/25.
//

import Observation
import Foundation

@Observable
class FavoriteRecipeViewModel {
    private let storageService: RecipeStorageService
    public var favoriteRecipes: [Recipe] = []
    public var error: Error?
    public var isLoading: Bool = false
    
    init(storageService: RecipeStorageService) {
        self.storageService = storageService
    }
    
    func initFavoriteRecipes() async {
        self.isLoading = true
        await fetchFavoriteRecipes()
        self.isLoading = false
    }
    
    func fetchFavoriteRecipes() async {
        do {
            let recipes = try await storageService.fetchFavoriteRecipes()
            self.favoriteRecipes = recipes
        } catch {
            self.error = error
        }
    }
    
    func deleteFavoriteRecipe(_ recipe: Recipe) async {
        do {
            try await storageService.deleteFavoriteRecipe(recipe)
            await fetchFavoriteRecipes()
        } catch {
            self.error = error
        }
    }
}
