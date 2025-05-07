//
//  RecipeService.swift
//  testingApp
//
//  Created by Rama Adi Nugraha on 07/05/25.
//

/// `RecipeService` is a protocol that defines the requirements for any service
/// responsible for fetching a list of recipes. This abstraction allows you to
/// provide different implementations, such as a live network service or a local
/// mock service for testing and previews.
///
/// - Why use a protocol?
///   - Protocols allow you to swap out the underlying implementation without
///     changing the rest of your app. For example, you can use a fake service
///     in unit tests and a real API service in production.
///
/// ## Example Usage
/// ```swift
/// // Using the real service (see LiveRecipeService.swift)
/// let realService: RecipeService = LiveRecipeService()
/// Task {
///     do {
///         let recipes = try await realService.fetchRecipes()
///         print("Fetched \(recipes.recipes.count) recipes from API")
///     } catch {
///         print("Error fetching recipes: \(error)")
///     }
/// }
///
/// // Using the fake service (see FakeRecipeService.swift)
/// let fakeService: RecipeService = FakeRecipeService()
/// Task {
///     do {
///         let recipes = try await fakeService.fetchRecipes()
///         print("Fetched \(recipes.recipes.count) recipes from local JSON")
///     } catch {
///         print("Error fetching recipes: \(error)")
///     }
/// }
/// ```
///
/// ## Requirements
/// - Conforming types must implement `fetchRecipes()`, which asynchronously
///   fetches and returns a `Recipes` object (a list of recipes).
/// - The function can throw errors, for example if the network is unavailable
///   or the data is invalid.
protocol RecipeService {
    /// Fetches a list of recipes asynchronously.
    ///
    /// - Returns: A `Recipes` object containing the fetched recipes.
    /// - Throws: An error if the fetch fails (e.g., network error, decoding error).
    func fetchRecipes() async throws -> Recipes
}
