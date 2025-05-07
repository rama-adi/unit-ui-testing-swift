//
//  BaseTest.swift
//  testingApp
//
//  Created by Rama Adi Nugraha on 08/05/25.
//


//
//  BaseTest.swift
//  testingAppUITests
//
//  Created by Rama Adi Nugraha on 08/05/25.
//

import XCTest

class BaseTest: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Always stop immediately when a failure occurs
        continueAfterFailure = false
        
        // Initialize the app
        app = XCUIApplication()
    }
    
    override func tearDownWithError() throws {
        // Perform any common teardown operations here
        app = nil
    }
    
    /**
     Launches the app with test-specific configurations.
     
     - Parameters:
     - testName: Optional test name for identification in logs
     - launchArguments: Additional launch arguments beyond the default test arguments
     - launchEnvironment: Additional environment variables to set
     */
    func launchApp(
        testName: String? = nil,
        launchArguments: [String] = [],
        launchEnvironment: [String: String] = [:]
    ) {
        // Set the test name if provided (useful for debugging)
        if let testName = testName {
            app.launchEnvironment["UI_TEST_NAME"] = testName
        }
        
        // Add custom launch arguments
        app.launchArguments.append(contentsOf: launchArguments)
        
        // Set standard test environment flag
        app.launchEnvironment["IS_UITESTING"] = "1"
        
        // Add any additional environment variables
        for (key, value) in launchEnvironment {
            app.launchEnvironment[key] = value
        }
        
        // Launch the app with all configurations
        app.launch()
    }
    
    /**
     Helper method to wait for an element to appear with a timeout.
     
     - Parameters:
     - element: The XCUIElement to wait for
     - timeout: The maximum time to wait in seconds
     - message: Custom message for the assertion failure
     - Returns: The element that was found
     */
    @discardableResult
    func waitForElement(
        _ element: XCUIElement,
        timeout: TimeInterval = 5,
        message: String = "Element did not appear"
    ) -> XCUIElement {
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == true"),
            object: element
        )
        
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        XCTAssertEqual(result, .completed, message)
        
        return element
    }
}
