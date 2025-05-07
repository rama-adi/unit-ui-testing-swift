//
//  FavoriteRecipeView.swift
//  testingApp
//
//  Created by Rama Adi Nugraha on 08/05/25.
//

import SwiftUI

struct FavoriteRecipeView: View {
    @State var viewModel: FavoriteRecipeViewModel
    
    let storageService: RecipeStorageService
    
    init(storageService: RecipeStorageService) {
        self.storageService = storageService
        _viewModel = State(initialValue: FavoriteRecipeViewModel(storageService: storageService)
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
                } else if viewModel.favoriteRecipes.isEmpty {
                    ContentUnavailableView(
                        "No favorite recipes found",
                        systemImage: "list.bullet",
                        description: Text("Start saving some recipes so you can view them here.")
                    )
                } else {
                    List {
                        ForEach(viewModel.favoriteRecipes) { recipe in
                            NavigationLink(destination:
                                            RecipeDetailView(storageService: storageService, recipe: recipe)
                            ) {
                                RecipeCardView(recipe: recipe)
                            }
                        }
                        .onDelete { indexSet in
                            Task {
                                for index in indexSet {
                                    let recipe = viewModel.favoriteRecipes[index]
                                    await viewModel.deleteFavoriteRecipe(recipe)
                                }
                            }
                        }
                    }
                    
                }
            }
            .task {
                await viewModel.initFavoriteRecipes()
            }
            .navigationTitle("Favorite Recipes")
        }
    }
}

#Preview("Example prefilled") {
    FavoriteRecipeView(
        storageService: PrefilledRecipeStorageService(randomized: true)
    )
}
