//
//  PrefilledRecipeStorageService.swift
//  testingApp
//
//  Created by Rama Adi Nugraha on 08/05/25.
//
import Foundation

/// `PrefilledRecipeStorageService` is a concrete implementation of the `RecipeStorageService` protocol.
/// This service is designed to provide a prefilled set of favorite recipes for use in previews, testing,
/// or demo environments. It leverages `FakeJSONMemoryStore` as its backend, ensuring that all data
/// persists only in memory for the duration of the app session, with no disk or network access.
///
/// ### How it works:
/// - On first fetch, it loads a bundled JSON file (`dummy-recipes.json`), selects the top 3 recipes,
///   and stores them in the in-memory store under a specific key.
/// - Subsequent fetches, as well as save and delete operations, interact only with the in-memory store.
/// - This approach ensures that favorite recipes are always available and consistent for UI previews or
///   test runs, while remaining isolated from persistent storage.
///
/// ### Dependency Details:
/// - **RecipeStorageService**: The protocol this struct conforms to. It defines the contract for saving,
///   fetching, and deleting favorite recipes asynchronously.
/// - **FakeJSONMemoryStore**: A singleton in-memory key-value store, ideal for test and preview scenarios.
///   It provides `save(_:forKey:)` and `load(_:forKey:)` methods for storing and retrieving Codable objects.
///
/// ### Usage Tips:
/// - This service is especially useful for SwiftUI previews or automated UI tests where you want a
///   predictable set of favorite recipes without relying on disk or network.
/// - By changing the key or the initial data source, you can easily adapt this pattern to provide
///   different sets of prefilled data or even an empty state.
/// - For scenarios where you want to simulate an empty favorites list, consider how you might
///   leverage the same protocol and memory store, but return an empty array from `fetchFavoriteRecipes()`.
///   This allows you to test empty state UI or behaviors without modifying your production code.
///
/// - See also: `RecipeStorageService.swift` for protocol requirements and further extension ideas.
struct PrefilledRecipeStorageService: RecipeStorageService {
    
    let randomized: Bool
    init(randomized: Bool = false) {
        self.randomized = randomized
    }
    
    func saveFavoriteRecipe(_ recipe: Recipe) async throws {
        // Save to in-memory store so favorites persist in-memory for the session
        var current = FakeJSONMemoryStore.shared.load([Recipe].self, forKey: "prefilled_favorite_recipes") ?? []
        if !current.contains(where: { $0.id == recipe.id }) {
            current.append(recipe)
            FakeJSONMemoryStore.shared.save(current, forKey: "prefilled_favorite_recipes")
        }
    }
    
    func fetchFavoriteRecipes() async throws -> [Recipe] {
        if let stored = FakeJSONMemoryStore.shared.load([Recipe].self, forKey: "prefilled_favorite_recipes") {
            return stored
        }
        // load JSON from dummy-recipes.json, and get the top 3
        let url = Bundle.main.url(forResource: "dummy-recipes", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let recipes = try decoder.decode(Recipes.self, from: data)
        
        let top3: [Recipe]
        if self.randomized {
            let shuffled = recipes.recipes.shuffled()
            top3 = Array(shuffled.prefix(3))
        } else {
            top3 = Array(recipes.recipes.prefix(3))
        }
        FakeJSONMemoryStore.shared.save(top3, forKey: "prefilled_favorite_recipes")
        return top3
    }
    
    func deleteFavoriteRecipe(_ recipe: Recipe) async throws {
        var current = FakeJSONMemoryStore.shared.load([Recipe].self, forKey: "prefilled_favorite_recipes") ?? []
        current.removeAll { $0.id == recipe.id }
        FakeJSONMemoryStore.shared.save(current, forKey: "prefilled_favorite_recipes")
    }
}
