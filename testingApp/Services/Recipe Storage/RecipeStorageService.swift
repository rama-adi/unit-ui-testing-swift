//
//  RecipeStorageService.swift
//  testingApp
//
//  Created by Rama Adi Nugraha on 07/05/25.
//

/// `RecipeStorageService` is a protocol that defines the requirements for any service
/// responsible for storing and retrieving a user's favorite recipes. This abstraction
/// allows you to provide different implementations, such as a live file-based storage
/// (see `LiveRecipeStorageService.swift`) or an in-memory mock for testing and previews.
///
/// - Why use a protocol?
///   - Protocols allow you to swap out the underlying implementation without
///     changing the rest of your app. For example, you can use a fake storage
///     in unit tests and a real persistent storage in production.
///
/// ## Example Usage
/// ```swift
/// // Using the real storage service (see LiveRecipeStorageService.swift)
/// let realStorage: RecipeStorageService = LiveRecipeStorageService()
/// Task {
///     do {
///         try await realStorage.saveFavoriteRecipe(recipe)
///         let favorites = try await realStorage.fetchFavoriteRecipes()
///         print("You have \(favorites.count) favorite recipes")
///     } catch {
///         print("Error saving or fetching favorites: \(error)")
///     }
/// }
///
/// // Using a fake/in-memory storage service for testing
/// // NOTE: This protocol does not provide a fake storage implementation.
/// // It is up to you to implement a fake storage service for testing,
/// // for example using the provided `FakeJSONMemoryStore` (see FakeJSONMemoryStore.swift).
/// // You might create a struct like:
/// // struct FakeRecipeStorageService: RecipeStorageService { ... }
/// // and use `FakeJSONMemoryStore.shared` to store and retrieve recipes.
/// ```
///
/// ## Requirements
/// - Conforming types must implement methods to save, fetch, and delete favorite recipes.
/// - All methods are asynchronous and can throw errors (e.g., if saving fails).
/// - The storage mechanism (file, memory, etc.) is up to the conforming type.
/// - This protocol does NOT provide a fake storage service; you must implement it yourself,
///   for example using `FakeJSONMemoryStore` as a backend for your fake service.
protocol RecipeStorageService {
    /// Saves a recipe to the user's favorites.
    ///
    /// - Parameter recipe: The `Recipe` to save as a favorite.
    /// - Throws: An error if the save operation fails.
    func saveFavoriteRecipe(_ recipe: Recipe) async throws

    /// Fetches all favorite recipes for the user.
    ///
    /// - Returns: An array of `Recipe` objects marked as favorites.
    /// - Throws: An error if the fetch operation fails.
    func fetchFavoriteRecipes() async throws -> [Recipe]

    /// Deletes a recipe from the user's favorites.
    ///
    /// - Parameter recipe: The `Recipe` to remove from favorites.
    /// - Throws: An error if the delete operation fails.
    func deleteFavoriteRecipe(_ recipe: Recipe) async throws
}
