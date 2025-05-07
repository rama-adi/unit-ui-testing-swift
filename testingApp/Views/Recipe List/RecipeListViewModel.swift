//
//  RecipeListViewModel.swift
//  testingApp
//
//  Created by Rama Adi Nugraha on 07/05/25.
//

import Observation

@Observable
class RecipeListViewModel {
    
    private let recipeService: RecipeService
   
    public var isLoading: Bool = false
    public var recipes: [Recipe] = []
    public var error: Error?
    
    init(recipeService: RecipeService) {
        self.recipeService = recipeService
    }
    
    func fetchRecipes() async {
        self.isLoading = true
        do {
            let recipes = try await recipeService.fetchRecipes()
            self.recipes = recipes.recipes
            self.isLoading = false
        } catch {
            print("Error fetching recipes: \(error)")
        }
    }
}
