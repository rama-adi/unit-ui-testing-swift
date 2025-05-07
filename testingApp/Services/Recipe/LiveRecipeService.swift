//
//  LiveRecipeService.swift
//  testingApp
//
//  Created by Rama Adi Nugraha on 07/05/25.
//

import Foundation

extension URLCache {
    static let imageCache = URLCache(
        memoryCapacity: 512*1000*1000,
        diskCapacity: 10*1000*1000*1000
    )
    
    static let recipeCache = URLCache(
        memoryCapacity: 64*1024*1024, // 64 MB for recipes
        diskCapacity: 256*1024*1024   // 256 MB for recipes
    )
}

struct LiveRecipeService: RecipeService {
    private static let cacheExpiry: TimeInterval = 30 * 60 // 30 minutes in seconds
    
    func fetchRecipes() async throws -> Recipes {
        guard let url = URL(string: "https://dummyjson.com/recipes") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        
        // Use the new recipeCache instead of shared
        let cache = URLCache.recipeCache
        
        // Check for cached response and validate expiry (30 minutes)
        if let cachedResponse = cache.cachedResponse(for: request) {
            if let userInfo = cachedResponse.userInfo,
               let cacheDate = userInfo["cacheDate"] as? Date,
               Date().timeIntervalSince(cacheDate) < Self.cacheExpiry {
                let decoder = JSONDecoder()
                return try decoder.decode(Recipes.self, from: cachedResponse.data)
            } else if cachedResponse.userInfo == nil {
                // If no userInfo, fallback to using the cache as long as it's not too old (legacy support)
                let decoder = JSONDecoder()
                return try decoder.decode(Recipes.self, from: cachedResponse.data)
            }
            // else: cache expired, continue to fetch from network
        }
        
        // Fetch from network
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Store with cacheDate in userInfo
        let cachedResponse = CachedURLResponse(
            response: response,
            data: data,
            userInfo: ["cacheDate": Date()],
            storagePolicy: .allowed
        )
        cache.storeCachedResponse(cachedResponse, for: request)
        
        let decoder = JSONDecoder()
        return try decoder.decode(Recipes.self, from: data)
    }
}
