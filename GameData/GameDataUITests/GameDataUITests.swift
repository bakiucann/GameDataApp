//
//  GameDataUITests.swift
//  GameDataUITests
//
//  Created by Baki Uçan on 11.07.2023.
//

import XCTest

final class GameDataUITests: XCTestCase {

    // Tüm işlevlerin test edildiği ana test fonksiyonu.
    func testAllFunctions() throws {

        // Uygulamayı başlatma.
        let app = XCUIApplication()
        app.launch()

        // Ana ekranı bulma.
        let element = app.scrollViews.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element

        // Ekranda sağa kaydırma (swipe) işlemleri.
        element.swipeLeft()
        element.swipeLeft()

        // Portal 2 oyununun detay sayfasına gitme ve favorilere ekleme işlemi.
        element.tap()
        let portal2NavigationBar = app.navigationBars["Portal 2"]
        let loveButton = portal2NavigationBar.buttons["love"]
        loveButton.tap()

        // Alt tab bardaki "Favorites" (Favoriler) sekmesine geçme.
        let tabBar = app.tabBars["Tab Bar"]
        let favoritesButton = tabBar.buttons["Favorites"]
        favoritesButton.tap()

        // "Home" (Ana Sayfa) sekmesine geçme.
        let homeButton = tabBar.buttons["Home"]
        homeButton.tap()

        // Favorilere eklenen oyunu favorilerden çıkarma işlemi ve tekrar favorilere ekleme.
        loveButton.tap()
        app.alerts["Remove from Favorites"].scrollViews.otherElements.buttons["Remove"].tap()
        favoritesButton.tap()
        homeButton.tap()
        loveButton.tap()

        // Portal 2 oyununun detay sayfasından geri dönme işlemi.
        portal2NavigationBar.buttons["Back"].tap()

        // Ana sayfada aşağı doğru kaydırma işlemi.
        app.collectionViews.containing(.other, identifier:"Vertical scroll bar, 4 pages").element.swipeUp()
    }
}
