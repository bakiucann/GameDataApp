//
//  GameDataUITests.swift
//  GameDataUITests
//
//  Created by Baki Uçan on 11.07.2023.
//

import XCTest

final class GameDataUITests: XCTestCase {

    func testAllFunctions() throws {

      let app = XCUIApplication()
      app.launch()
      let scrollViewsQuery = app.scrollViews
      let element = scrollViewsQuery.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
      element.swipeLeft()
      element.swipeLeft()

      let gamedataHomeviewNavigationBar = app.navigationBars["GameData.HomeView"]
      let searchGamesSearchField = gamedataHomeviewNavigationBar.searchFields["Search Games"]
      searchGamesSearchField.tap()

      let bKey = app/*@START_MENU_TOKEN@*/.keys["B"]/*[[".keyboards.keys[\"B\"]",".keys[\"B\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
      bKey.tap()

      let iKey = app/*@START_MENU_TOKEN@*/.keys["i"]/*[[".keyboards.keys[\"i\"]",".keys[\"i\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
      iKey.tap()

      let oKey = app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
      oKey.tap()

      let sKey = app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
      sKey.tap()

      app.collectionViews.cells.otherElements.containing(.staticText, identifier:"BioShock Infinite").element.tap()

      let bioshockInfiniteNavigationBar = app.navigationBars["BioShock Infinite"]
      let loveButton = bioshockInfiniteNavigationBar.buttons["love"]
      loveButton.tap()
      
      let tabBar = app.tabBars["Tab Bar"]
      tabBar.buttons["Favorites"].tap()
      tabBar.buttons["Home"].tap()
      loveButton.tap()
      bioshockInfiniteNavigationBar.buttons["Back"].tap()
      searchGamesSearchField.buttons["Clear text"].tap()
      gamedataHomeviewNavigationBar/*@START_MENU_TOKEN@*/.staticTexts["Cancel"]/*[[".buttons[\"Cancel\"].staticTexts[\"Cancel\"]",".staticTexts[\"Cancel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      app/*@START_MENU_TOKEN@*/.collectionViews.containing(.other, identifier:"Vertical scroll bar, 4 pages").element/*[[".collectionViews.containing(.other, identifier:\"Horizontal scroll bar, 1 page\").element",".collectionViews.containing(.other, identifier:\"Vertical scroll bar, 4 pages\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()


    }
}
