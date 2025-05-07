//
//  FakeRecipeService.swift.swift
//  testingApp
//
//  Created by Rama Adi Nugraha on 07/05/25.
//

import Foundation

struct FakeRecipeService: RecipeService {
    func fetchRecipes() async throws -> Recipes {
        // recipe is in main bundle called dummy-recipes.json
        guard let url = Bundle.main.url(forResource: "dummy-recipes", withExtension: "json") else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "File not found"])
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let recipes = try decoder.decode(Recipes.self, from: data)
        return recipes
    }
}
