//
//  FakeRecipeStorageService.swift
//  testingApp
//
//  Created by Rama Adi Nugraha on 07/05/25.

import Foundation

/// A fake, in-memory implementation of `RecipeStorageService` for testing and previews.
/// Uses `FakeJSONMemoryStore` as the backend store.
struct FakeRecipeStorageService: RecipeStorageService {
    private let store: FakeJSONMemoryStore
    private let favoritesKey = "favoriteRecipes"

    /// Initializes the fake storage service.
    /// - Parameter store: The memory store to use (defaults to `.shared`).
    init(store: FakeJSONMemoryStore = .shared) {
        self.store = store
    }

    /// Saves a recipe to the user's favorites.
    func saveFavoriteRecipe(_ recipe: Recipe) async throws {
        var current = await fetchFavoriteRecipesOrEmpty()
        // Avoid duplicates (by id)
        if !current.contains(where: { $0.id == recipe.id }) {
            current.append(recipe)
            store.save(current, forKey: favoritesKey)
        }
    }

    /// Fetches all favorite recipes for the user.
    func fetchFavoriteRecipes() async throws -> [Recipe] {
        return await fetchFavoriteRecipesOrEmpty()
    }

    /// Deletes a recipe from the user's favorites.
    func deleteFavoriteRecipe(_ recipe: Recipe) async throws {
        var current = await fetchFavoriteRecipesOrEmpty()
        current.removeAll { $0.id == recipe.id }
        store.save(current, forKey: favoritesKey)
    }

    /// Helper to fetch favorites or return empty array if none.
    private func fetchFavoriteRecipesOrEmpty() async -> [Recipe] {
        store.load([Recipe].self, forKey: favoritesKey) ?? []
    }
}