//
//  Recipe.swift
//  testingApp
//
//  Created by Rama Adi Nugraha on 07/05/25.
//

struct Recipe: Codable, Identifiable {
    let id: Int
    let name: String
    let ingredients, instructions: [String]
    let prepTimeMinutes, cookTimeMinutes, servings: Int
    let difficulty: Difficulty
    let cuisine: String
    let caloriesPerServing: Int
    let tags: [String]
    let userID: Int
    let image: String
    let rating: Double
    let reviewCount: Int
    let mealType: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, name, ingredients, instructions, prepTimeMinutes, cookTimeMinutes, servings, difficulty, cuisine, caloriesPerServing, tags
        case userID = "userId"
        case image, rating, reviewCount, mealType
    }
}
