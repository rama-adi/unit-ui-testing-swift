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
        WindowGroup {
            // Use fake implementations if running UI tests, otherwise use live implementations
            let isUITesting = ProcessInfo.processInfo.environment["IS_UITESTING"] == "1"
            ContentView(
                recipeService: isUITesting ? FakeRecipeService() : LiveRecipeService(),
                storageService: isUITesting ? LiveRecipeStorageService() : LiveRecipeStorageService()
            )
        }
    }
}
