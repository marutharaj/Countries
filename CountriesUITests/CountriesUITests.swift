//
//  CountriesUITests.swift
//  CountriesUITests
//
//  Created by Marutharaj Kuppusamy on 11/26/18.
//  Copyright © 2018 shell. All rights reserved.
//

import XCTest
import OHHTTPStubs

extension XCUIElement {
    func scrollToElement(parent: XCUIElement, element: XCUIElement) {
        while element.visible() == false {
            let startCoord = parent.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            let endCoord = startCoord.withOffset(CGVector(dx: 0.0, dy: -262))
            startCoord.press(forDuration: 0.01, thenDragTo: endCoord)
        }
    }
    
    func visible() -> Bool {
        guard self.exists && self.isHittable && !self.frame.isEmpty else {
            return false
        }
        
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }
}

class CountriesUITests: XCTestCase {

    func toggleWiFi() {
        let app = XCUIApplication()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        
        // open control center
        let coord1 = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.99))
        let coord2 = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
        coord1.press(forDuration: 0.1, thenDragTo: coord2)
        
        let wifiButton = springboard.switches["wifi-button"]
        wifiButton.tap()
        
        app.launch()
    }
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func waitForCountryToLoad() {
        let app = XCUIApplication()

        let startTime = NSDate()
        var duration: TimeInterval
        var cellCount1: UInt = UInt(app.tables.cells.count)
        var cellCount2: UInt = UInt(app.tables.cells.count)
        while cellCount1 != cellCount2 {
            cellCount1 = UInt(app.tables.cells.count)
            cellCount2 = UInt(app.tables.cells.count)
            duration = NSDate().timeIntervalSince(startTime as Date)
            if duration > 60 {
                XCTFail("Took too long waiting for countries to load.")
            }
        }
    }
    
    func verifyCountryCell(cellIndex: Int) {
        let app = XCUIApplication()
        let secondCountryCell = app.tables.cells.element(boundBy: cellIndex)
        let countryNameLabel = secondCountryCell.staticTexts.firstMatch
        let countryFlagImageView = secondCountryCell.images.firstMatch
        XCTAssertTrue(secondCountryCell.exists, "Country was not loaded.")
        XCTAssertTrue(countryNameLabel.exists, "Country name label was not visible.")
        XCTAssertTrue(countryFlagImageView.exists, "Country flag was not visible.")
    }
    
    func verifyCountryDetail(online: Bool) {
        let app = XCUIApplication()

        let secondCountryCell = app.tables.cells.element(boundBy: 1)
        let countryName = secondCountryCell.staticTexts.firstMatch.label
        app.tables.cells.element(boundBy: 1).tap()
        XCTAssertTrue(app.navigationBars.firstMatch.waitForExistence(timeout: TimeInterval(2.0)), "Country detail was not loaded.")
        XCTAssertTrue(app.navigationBars.firstMatch.identifier == countryName, "Country name was not displayed in the navigation bar.")
        //Country capital
        let countryCapital = app.tables.cells.element(boundBy: 0).staticTexts.firstMatch
        XCTAssertTrue(countryCapital.label == "Mexico City", "Country capital was not visible.")
        //Country calling code
        let countryCallingCode = app.tables.cells.element(boundBy: 1).staticTexts.firstMatch
        XCTAssertTrue(countryCallingCode.label == "52", "Country calling code was not visible.")
        //Time zone
        let countryTimeZone = app.tables.cells.element(boundBy: 2).staticTexts.firstMatch
        XCTAssertTrue(countryTimeZone.label == "UTC-08:00", "Country time zone was not visible.")
        //Currency code
        app.scrollToElement(parent: app.tables.element, element: app.tables.cells.element(boundBy: 5))
        let countryCurrencyName = app.tables.cells.element(boundBy: 5).staticTexts.firstMatch
        XCTAssertTrue(countryCurrencyName.label == "Name: Mexican peso", "Country currency name was not visible.")
        //Currency code
        let countryLanguageName = app.tables.cells.element(boundBy: 6).staticTexts.firstMatch
        XCTAssertTrue(countryLanguageName.label == "Name: Spanish", "Country language name was not visible.")
        if online {
            XCTAssertTrue(app.buttons.firstMatch.exists, "Save offline button was not visible.")
        } else {
            XCTAssertFalse(app.buttons.firstMatch.exists, "Save offline button was  visible.")
        }
        app.navigationBars.buttons.firstMatch.tap()
        XCTAssertTrue(secondCountryCell.exists, "App was not redirected to country list view.")
    }
    
    func testVerifyCountryElementVisible() {
        let app = XCUIApplication()
        XCTAssertTrue(app.searchFields.element.exists, "Search bar does not exist.")
        XCTAssertTrue(app.tables.element.exists, "Country table view does not exist.")
    }
    
    func testVerifyLoadCountry() {
        let app = XCUIApplication()
        
        app.searchFields.element.tap()
        app.searchFields.element.typeText("x")
        waitForCountryToLoad()
        verifyCountryCell(cellIndex: 1)
    }
    
    func testVerifySelectAllCountries() {
        let app = XCUIApplication()
        
        app.searchFields.element.tap()
        app.searchFields.element.typeText("x")
        
        waitForCountryToLoad()
        
        for index in 0..<app.tables.cells.count {
            let countryName = app.tables.cells.element(boundBy: index).staticTexts.firstMatch.label
            let countryCell = app.tables.cells.element(boundBy: index)
            countryCell.tap()
            XCTAssertTrue(app.navigationBars.firstMatch.identifier == countryName, "Country name was not displayed in the navigation bar.")
            app.navigationBars.buttons.firstMatch.tap()
            XCTAssertTrue(countryCell.exists, "App was not redirected to country list view")
            sleep(1) //Don't hog the CPU
        }
    }
    
    func testVerifySelectSingleCountry() {
        let app = XCUIApplication()
        
        app.searchFields.element.tap()
        app.searchFields.element.typeText("x")
        
        waitForCountryToLoad()
        
        let secondCountryCell = app.tables.cells.element(boundBy: 1)
        let countryName = secondCountryCell.staticTexts.firstMatch.label
        app.tables.cells.element(boundBy: 1).tap()
        XCTAssertTrue(app.navigationBars.firstMatch.waitForExistence(timeout: TimeInterval(2.0)), "Country detail was not loaded.")
        XCTAssertTrue(app.navigationBars.firstMatch.identifier == countryName, "Country name was not displayed in the navigation bar.")
        app.navigationBars.buttons.firstMatch.tap()
        XCTAssertTrue(secondCountryCell.exists, "App was not redirected to country list view")
    }
    
    func testVerifyScrollCountries() {
        let app = XCUIApplication()
        
        app.searchFields.element.tap()
        app.searchFields.element.typeText("w")
        
        waitForCountryToLoad()
        let lastCountryCell = app.tables.cells.element(boundBy: app.tables.cells.count)
        app.scrollToElement(parent: app.tables.element, element: lastCountryCell)
        XCTAssertTrue(lastCountryCell.exists, "App unable to scroll upto last country in the country list.")
        let firstCountryCell = app.tables.cells.element(boundBy: 0)
        app.scrollToElement(parent: app.tables.element, element: firstCountryCell)
        XCTAssertTrue(firstCountryCell.exists, "App unable to scroll upto first country in the country list.")
    }

    func testVerifyCountryDetailElementVisible() {
        let app = XCUIApplication()
        
        app.searchFields.element.tap()
        app.searchFields.element.typeText("x")
        
        waitForCountryToLoad()
        verifyCountryDetail(online: true)
    }
    
    func testVerifyCountryDetailSaveOffline() {
        let app = XCUIApplication()
        
        app.searchFields.element.tap()
        app.searchFields.element.typeText("x")
        
        waitForCountryToLoad()
        
        for index in 0..<app.tables.cells.count {
            let countryCell = app.tables.cells.element(boundBy: index)
            countryCell.tap()
            XCTAssertTrue(app.navigationBars.firstMatch.waitForExistence(timeout: TimeInterval(2.0)), "Country detail was not loaded.")
            XCTAssertTrue(app.buttons.firstMatch.exists, "Save offline button was not visible.")
            app.buttons.firstMatch.tap()
            let alert = app.alerts.element
            XCTAssertTrue(alert.staticTexts.firstMatch.label == "Countries", "Alert was not displayed.")
        
            alert.buttons.firstMatch.tap()
            XCTAssertFalse(alert.exists, "Alert was not closed.")
            app.navigationBars.buttons.firstMatch.tap()
            sleep(1) //Don't hog the CPU
        }
    }
    
    func testVerifyLoadCountryOffline() {
        toggleWiFi()
        
        waitForCountryToLoad()
        verifyCountryCell(cellIndex: 1)
    }
    
    func testVerifySearchCountryOffline() {
        toggleWiFi()
        
        let app = XCUIApplication()
        app.searchFields.element.tap()
        app.searchFields.element.typeText("x")
        waitForCountryToLoad()
        verifyCountryCell(cellIndex: 1)
    }
    
    func testVerifyCountryDetailOffline() {
        toggleWiFi()
        
        let app = XCUIApplication()
        app.searchFields.element.tap()
        app.searchFields.element.typeText("x")
        waitForCountryToLoad()
        verifyCountryDetail(online: false)
    }
}
