//
//  Recipes.swift
//  testingApp
//
//  Created by Rama Adi Nugraha on 07/05/25.
//


struct Recipes: Codable {
    let recipes: [Recipe]
    let total, skip, limit: Int
}