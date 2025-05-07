//
//  LiveRecipeService.swift
//  testingApp
//
//  Created by Rama Adi Nugraha on 07/05/25.
//

import Foundation

struct LiveRecipeService: RecipeService {
    func fetchRecipes() async throws -> Recipes {
        // Create URL
        guard let url = URL(string: "https://dummyjson.com/recipes") else {
            throw URLError(.badURL)
        }
        
        // Create URL request
        let request = URLRequest(url: url)
        
        // Get data from API
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check response is HTTP response and status code is 200
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Decode JSON data into Recipes
        let decoder = JSONDecoder()
        return try decoder.decode(Recipes.self, from: data)
    }
}
