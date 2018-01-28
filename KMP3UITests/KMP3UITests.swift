//
//  KMP3UITests.swift
//  KMP3UITests
//
//  Created by KhuongPham on 1/26/18.
//

import XCTest

class KMP3UITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        app = XCUIApplication()
    }
    
    func testScrolling() {
        app.launch()
        
        let tableView = app.tables.element(boundBy: 0)
        tableView.swipeUp()
        tableView.swipeUp()
    }
    
    func testPlayAndPause() {
        app.launch()
        
        let firstCell = app.cells.element(boundBy: 0)
        let playButton = firstCell.buttons["ic play rounded"]
        playButton.tap()
        
        sleep(3)
        
        let pauseButton = firstCell.buttons["ic pause rounded"]
        pauseButton.tap()
        
        sleep(2)
    }
    
}
