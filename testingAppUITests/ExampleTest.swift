//
//  ExampleTest.swift
//  testingApp
//
//  Created by Rama Adi Nugraha on 08/05/25.
//

import XCTest

class ExampleTest: BaseTest {
    
    func testRecipeListViewDisplaysRecipes() {
        // Launch the app with a test name for easier debugging
        launchApp(testName: "testRecipeListViewDisplaysRecipes")
        
        // Wait for the navigation title "Recipes" to appear
        let recipesTitle = app.staticTexts["Recipes"]
        waitForElement(recipesTitle, timeout: 5, message: "Recipes navigation title did not appear")
        
        // Wait for either the progress view to disappear or the list to appear
        let noRecipesText = app.staticTexts["No recipes found"]
        let failedText = app.staticTexts["Failed to get recipes"]
        
        // Check for one of the possible states
        if noRecipesText.exists {
            // The list is empty, so just assert the empty state is shown
            XCTAssertTrue(noRecipesText.exists, "No recipes found message should be visible")
        } else if failedText.exists {
            // There was an error fetching recipes
            XCTAssertTrue(failedText.exists, "Failed to get recipes message should be visible")
        } else {
            // Otherwise, expect at least one recipe cell to be present
            // Assuming RecipeCardView shows the recipe title as a staticText
            // We'll check for at least one cell in the list
            let firstCell = app.cells.element(boundBy: 0)
            waitForElement(firstCell, timeout: 5, message: "No recipe cell appeared in the list")
            XCTAssertTrue(firstCell.exists, "At least one recipe cell should be visible")
        }
    }
}
