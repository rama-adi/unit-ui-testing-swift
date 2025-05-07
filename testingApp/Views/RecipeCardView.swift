//
//  RecipeCardView.swift
//  testingApp
//
//  Created by Rama Adi Nugraha on 08/05/25.
//
import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe

    var description: String {
        let mealType = recipe.mealType.first ?? ""
        let calories = recipe.caloriesPerServing
        let caloriesString = String.localizedStringWithFormat(
            NSLocalizedString("%d calorie per serving", comment: "Calories per serving (singular)"),
            calories
        )
        let caloriesPerServingString: String
        if calories == 1 {
            caloriesPerServingString = caloriesString
        } else {
            caloriesPerServingString = String.localizedStringWithFormat(
                NSLocalizedString("%d calories per serving", comment: "Calories per serving (plural)"),
                calories
            )
        }

        // Determine if we should use "a" or "an" before the difficulty
        let difficulty = recipe.difficulty
        let firstLetter = difficulty.rawValue.prefix(1).lowercased()
        let vowels = ["a", "e", "i", "o", "u"]
        let article = vowels.contains(firstLetter) ? "An" : "A"

        return "\(article) \(difficulty) difficulty \(recipe.cuisine) \(mealType) with \(caloriesPerServingString)"
    }

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // Recipe Image with caching using LiveRecipeService's imageCache
            AsyncImage(
                url: URL(string: recipe.image),
                transaction: Transaction(animation: .default)
            ) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.15))
                        Image(systemName: "photo")
                            .foregroundColor(.gray.opacity(0.4))
                            .font(.system(size: 28))
                    }
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure(_):
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.15))
                        Image(systemName: "photo")
                            .foregroundColor(.gray.opacity(0.4))
                            .font(.system(size: 28))
                    }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 72, height: 72)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.black.opacity(0.06), radius: 2, x: 0, y: 1)
            .onAppear {
                // Preload/caching logic for image using LiveRecipeService's imageCache
                guard let url = URL(string: recipe.image) else { return }
                let request = URLRequest(url: url)
                // Check if image is already cached
                if URLCache.imageCache.cachedResponse(for: request) == nil {
                    // Download and cache the image
                    URLSession.shared.dataTask(with: request) { data, response, _ in
                        if let data = data, let response = response {
                            let cachedResponse = CachedURLResponse(response: response, data: data)
                            URLCache.imageCache.storeCachedResponse(cachedResponse, for: request)
                        }
                    }.resume()
                }
            }

            // Recipe Info
            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)

                HStack(spacing: 10) {
                    Label("\(recipe.prepTimeMinutes + recipe.cookTimeMinutes) min", systemImage: "clock")
                    Label(recipe.cuisine, systemImage: "globe.europe.africa")
                }
                .font(.caption)
                .foregroundColor(.accentColor.opacity(0.8))

                Text(description)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .padding(.vertical, 4)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 2)
    }
}
