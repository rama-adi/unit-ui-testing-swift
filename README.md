#  Test case checklist
To get maximum score for this assignment, follow the checklist below. Each requirement must be implemented exactly as specified.

## Dependency injection
- [ ] Create a `FakeRecipeStorageService` that conforms to `RecipeStorageService` protocol
  - The class must be named exactly `FakeRecipeStorageService` and implement all methods in the protocol
  - Use `FakeJSONMemoryStore.shared` as your backend storage mechanism (see `FakeJSONMemoryStore.swift`)
  - For `saveFavoriteRecipe` method: encode the recipe and store it in the memory store using an appropriate key
  - For `fetchFavoriteRecipes` method: retrieve all favorites from the memory store as an array
  - For `deleteFavoriteRecipe` method: remove the specific recipe from the memory store
  - Your implementation must have zero disk access or network calls
- [ ] Ensure proper dependency injection in all view models:
  - `RecipeListViewModel(recipeService: RecipeService)` - service must be passed through constructor
  - `RecipeDetailViewModel(storageService: RecipeStorageService, recipe: Recipe)` - both parameters must be passed through constructor  
  - `FavoriteRecipeViewModel(storageService: RecipeStorageService)` - service must be passed through constructor
  - Verify that no concrete implementations (like `LiveRecipeService`) are directly referenced inside the view models
- [ ] Create test-specific implementations:
  - Create a `ThrowingRecipeService` that conforms to `RecipeService` but always throws an error
  - Create an `EmptyRecipeService` that conforms to `RecipeService` but returns an empty list of recipes
- [ ] Setup proper preview configurations:
  - Update all `#Preview` code to use fake implementations (`FakeRecipeService` and `FakeRecipeStorageService`)
  - Add multiple preview cases using `#Preview(...)` with descriptive names for different states:
    - Empty state preview: use `EmptyRecipeService` to show UI when no recipes exist
    - Error state preview: use `ThrowingRecipeService` to simulate error conditions in the UI
    - Loaded state preview: use `FakeRecipeService` with sample data

## Unit test
- [ ] Create unit tests for `RecipeListViewModel`
  - Test `fetchRecipes()` method with a working fake service that returns test recipes
  - Verify `recipes` property is populated correctly after fetch (check array length and content)
  - Test `fetchRecipes()` with a failing service and verify error handling (check `error` property)
  - Verify `isLoading` property changes from true to false during fetch operation
- [ ] Create comprehensive tests for `RecipeDetailViewModel`
  - Test `toggleFavorite()` method to add a recipe to favorites when not favorited
  - Test `toggleFavorite()` method to remove a recipe from favorites when already favorited
  - Test `loadFavoriteStatus()` method correctly sets `isFavorite` property based on stored favorites
  - Test error handling during favorite operations (check `errorMessage` property)
  - Verify toggling favorite updates the `isFavorite` boolean property
- [ ] Create unit tests for `FavoriteRecipeViewModel`
  - Test `initFavoriteRecipes()` and `fetchFavoriteRecipes()` with mock recipes
  - Test `deleteFavoriteRecipe()` method removes a specific recipe from favorites
  - Verify `favoriteRecipes` array updates correctly after deletion (check new array content)
  - Test error handling when storage service operations fail
  - Verify `isLoading` property changes appropriately during fetch operations
- [ ] Ensure complete test isolation:
  - Use `FakeRecipeService` or appropriate test doubles in all view model tests
  - Use `FakeRecipeStorageService` with `FakeJSONMemoryStore` for all storage-related tests
  - Verify no file I/O occurs during tests (check Xcode debugger/console for file access)
  - Test that setting up previews with test implementations works correctly

## Automated UI Test
- [X] Create a base XCUITest class with proper setup:
  - Implement a method to launch the app with test-specific configurations
  - Create a custom environment (`IS_UITESTING`) that your app detects to use fake implementations
  - Modify your app to check for this argument and use fake services when present
  - Create helper methods for common UI interactions to avoid code duplication
- [ ] Recipe List View Tests:
  - Test scrolling through recipe list by finding elements by identifier and swiping
  - Test tapping on a specific recipe by identifier and verify navigation to detail view 
  - Verify recipe information displayed correctly by checking text elements match expected values
  - Test pull-to-refresh functionality if implemented
- [ ] Recipe Detail View Tests:
  - Test tapping the favorite button and verify the UI updates (button appearance changes)
  - Test unfavoriting by tapping the button again and verify UI reflects the change
  - Verify all recipe information (title, ingredients, steps) is displayed correctly
  - Test navigation back to recipe list by tapping the back button
  - Verify that favoriting a recipe persists when navigating back and forth
- [ ] Favorites View Tests:
  - Test switching to the Favorites tab and verify the tab appears
  - Verify only recipes marked as favorites appear in the list (no non-favorites)
  - Test the swipe-to-delete gesture on a favorited recipe
  - Verify the recipe disappears from the list after swipe-delete action
  - Test the empty state view when no favorites exist
  - Verify adding a favorite in detail view causes it to appear in favorites list
- [ ] Test environment integrity:
  - Add assertions to verify no network activity occurs during tests
  - Add a test to verify app state resets properly between test runs
  - Ensure all UI tests use fake implementations through proper launch arguments
  - Verify no real user data is affected by closing and reopening the app after tests

## Common Integration Test Scenarios
- [ ] Test favorite persistence workflow:
  - Add a recipe to favorites from detail view
  - Navigate to favorites tab and verify it appears
  - Delete it from favorites tab
  - Navigate back to detail view and verify it shows as not favorited
- [ ] Test data isolation:
  - Create a test that verifies restarting the app during testing doesn't affect in-memory test data
  - Verify different test runs don't interfere with each other
