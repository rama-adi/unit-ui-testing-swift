//
//  RecipeListView.swift
//  testingApp
//
//  Created by Rama Adi Nugraha on 07/05/25.
//

import SwiftUI

struct RecipeListView: View {
    @State var viewModel: RecipeListViewModel
    
    var storageService: RecipeStorageService
    
    init(
        recipeService: RecipeService,
        storageService: RecipeStorageService
    ) {
        self.storageService = storageService
        _viewModel = State(wrappedValue: RecipeListViewModel(recipeService: recipeService)
        )
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    ContentUnavailableView(
                        "Failed to get recipes",
                        systemImage: "exclamationmark.triangle.fill",
                        description: Text(error.localizedDescription)
                    )
                } else if viewModel.recipes.isEmpty {
                    ContentUnavailableView(
                        "No recipes found",
                        systemImage: "list.bullet",
                        description: Text("There are no recipes to display.")
                    )
                } else {
                    List {
                        ForEach(viewModel.recipes) { recipe in
                            NavigationLink(destination: RecipeDetailView(
                                storageService: storageService,
                                recipe: recipe)
                            ) {
                                RecipeCardView(recipe: recipe)
                            }
                        }
                    }
                }
            }
            .task {
                await viewModel.fetchRecipes()
            }
            .navigationTitle("Recipes")
        }
    }
}



#Preview("Dummy recipe list") {
    RecipeListView(
        recipeService: FakeRecipeService(),
        storageService: FakeRecipeStorageService())
}

// Example on adding more preview case
#Preview("Live recipe list") {
    RecipeListView(
        recipeService: LiveRecipeService(),
        storageService: LiveRecipeStorageService()
    )
}
