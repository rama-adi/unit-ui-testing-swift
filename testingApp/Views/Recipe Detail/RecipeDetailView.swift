//
//  RecipeDetailView.swift
//  testingApp
//
//  Created by Rama Adi Nugraha on 07/05/25.
//

import SwiftUI

struct RecipeDetailView: View {
    @State var viewModel: RecipeDetailViewModel
    let recipe: Recipe

    init(
        storageService: RecipeStorageService,
        recipe: Recipe
    ) {
        self.recipe = recipe
        _viewModel = State(wrappedValue: RecipeDetailViewModel(
            storageService: storageService, recipe: recipe
        ))
    }

    var body: some View {
        NavigationStack {
            List {
                // Recipe Image with caching using LiveRecipeService's imageCache
                Section {
                    AsyncImage(
                        url: URL(string: recipe.image),
                        transaction: Transaction(animation: .default)
                    ) { phase in
                        switch phase {
                        case .empty:
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.gray.opacity(0.15))
                                Image(systemName: "photo")
                                    .foregroundColor(.gray.opacity(0.4))
                                    .font(.system(size: 40))
                            }
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure(_):
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.gray.opacity(0.15))
                                Image(systemName: "photo")
                                    .foregroundColor(.gray.opacity(0.4))
                                    .font(.system(size: 40))
                            }
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                    .listRowInsets(EdgeInsets())
                    .onAppear {
                        // Preload/caching logic for image using LiveRecipeService's imageCache
                        guard let url = URL(string: recipe.image) else { return }
                        let request = URLRequest(url: url)
                        // Check if image is already cached
                        if URLCache.imageCache.cachedResponse(for: request) == nil {
                            // If not cached, fetch and cache it
                            let task = URLSession.shared.dataTask(with: request) { data, response, _ in
                                if let data = data, let response = response {
                                    let cachedResponse = CachedURLResponse(response: response, data: data)
                                    URLCache.imageCache.storeCachedResponse(cachedResponse, for: request)
                                }
                            }
                            task.resume()
                        }
                    }
                }

                // Quick Info
                Section {
                    Label("\(recipe.prepTimeMinutes + recipe.cookTimeMinutes) min", systemImage: "clock")
                    Label(recipe.cuisine, systemImage: "globe.europe.africa")
                    Label(recipe.difficulty.rawValue.capitalized, systemImage: "flame")
                    Label("\(recipe.caloriesPerServing) cal", systemImage: "bolt.heart")
                }

                // Ingredients
                Section(header: Text("Ingredients").font(.headline)) {
                    ForEach(recipe.ingredients, id: \.self) { ingredient in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 8))
                                .foregroundColor(.accentColor)
                                .padding(.top, 4)
                            Text(ingredient)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                }

                // Instructions
                Section(header: Text("Instructions").font(.headline)) {
                    ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { idx, step in
                        HStack(alignment: .top, spacing: 8) {
                            Text("\(idx + 1).")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.accentColor)
                                .frame(width: 24, alignment: .leading)
                            Text(step)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(recipe.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task { await viewModel.toggleFavorite() }
                    }) {
                        Label(
                            viewModel.isFavorite ? "Remove from favorites" : "Add to favorites",
                            systemImage: viewModel.isFavorite ? "heart.fill" : "heart"
                        )
                        .foregroundColor(viewModel.isFavorite ? .red : .gray)
                    }
                }
            }
            .alert(item: $viewModel.errorMessage) { error in
                Alert(
                    title: Text("Error"),
                    message: Text(error.message),
                    dismissButton: .default(Text("OK"))
                )
            }
            .task {
                await viewModel.loadFavoriteStatus()
            }
        }
    }
}

#Preview {
    RecipeDetailView(
        storageService: FakeRecipeStorageService(),
        recipe: Recipe(
            id: 1,
            name: "Spaghetti Carbonara",
            ingredients: ["200g spaghetti", "100g pancetta", "2 large eggs", "50g pecorino cheese", "50g parmesan", "Black pepper", "Salt"],
            instructions: [
                "Boil the spaghetti in salted water.",
                "Fry the pancetta until crisp.",
                "Beat the eggs and mix with the cheeses.",
                "Drain the pasta and combine with pancetta.",
                "Remove from heat, add egg and cheese mixture, and stir quickly.",
                "Season with black pepper and serve."
            ],
            prepTimeMinutes: 10,
            cookTimeMinutes: 20,
            servings: 2,
            difficulty: .easy,
            cuisine: "Italian",
            caloriesPerServing: 450,
            tags: ["pasta", "italian", "quick"],
            userID: 123,
            image: "https://images.unsplash.com/photo-1504674900247-0877df9cc836",
            rating: 4.7,
            reviewCount: 128,
            mealType: ["Dinner"]
        )
    )
}
