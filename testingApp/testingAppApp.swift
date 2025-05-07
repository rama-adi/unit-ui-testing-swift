//
//  testingAppApp.swift
//  testingApp
//
//  Created by Rama Adi Nugraha on 07/05/25.
//

import SwiftUI

@main
struct testingAppApp: App {
    var body: some Scene {
        // Anything here must use live implementations
        // Since this is the main entry point of the app
        // For preview, anything inside #Preview must use
        // fake implementations
        WindowGroup {
            ContentView(
                recipeService: LiveRecipeService(),
                storageService: LiveRecipeStorageService()
            )
        }
    }
}
