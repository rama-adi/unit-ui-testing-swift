//
//  ContentView.swift
//  testingApp
//
//  Created by Rama Adi Nugraha on 07/05/25.
//

import SwiftUI

struct ContentView: View {
    var recipeService: RecipeService
    var storageService: RecipeStorageService

    var body: some View {
        TabView {
            Tab("All Recipes", systemImage: "list.bullet") {
                RecipeListView(
                    recipeService: recipeService,
                    storageService: storageService
                )
            }
            
            Tab("Favorites", systemImage: "heart") {
                FavoriteRecipeView(storageService: storageService)
            }
        }
    }
}

#Preview {
    // Example providing fake implementations so that
    // Previews run without needing to fetch data from the internet
    // or store data to disk
    ContentView(
        recipeService: FakeRecipeService(),
        storageService: FakeRecipeStorageService()
    )
}
