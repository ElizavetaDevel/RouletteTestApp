//
//  RouletteCaseStoreTests.swift
//  RouletteTestAppTests
//
//  Created by superuser on 4/8/24.
//

import XCTest
@testable import RouletteTestApp

class RouletteCaseStoreTests: XCTestCase {
    
    var rouletteCaseStore: RouletteCaseStore!
    var mockStorageService: MockStorageService!

    override func setUp() {
        super.setUp()
        mockStorageService = MockStorageService()
        rouletteCaseStore = RouletteCaseStore(storage: mockStorageService)
    }

    override func tearDown() {
        rouletteCaseStore = nil
        mockStorageService = nil
        super.tearDown()
    }

    func testAddRouletteCase_NewState() async {
        let newState = RouletteCase(prizeForDay: [0: .heart, 1: .fire, 2: .sunglasses])

        await rouletteCaseStore.add(newState)

        XCTAssertNotNil(mockStorageService.storage["rouletteCaseKey"])
        XCTAssertEqual(mockStorageService.storage["rouletteCaseKey"] as? RouletteCase, newState)
    }

    func testUpdateRouletteCase_ExistingState() async {
        let existingState = RouletteCase(prizeForDay: [0: .heart, 1: .fire, 2: .sunglasses])
        mockStorageService.storage["rouletteCaseKey"] = existingState

        let newState = RouletteCase(prizeForDay: [0: .heart])
        await rouletteCaseStore.update(newState)
        
        XCTAssertEqual(mockStorageService.storage["rouletteCaseKey"] as? RouletteCase, newState)
    }

    func testGetRouletteCase_Success() async {
        let stateToStore = RouletteCase(prizeForDay: [0: .heart, 1: .fire, 2: .sunglasses])
        mockStorageService.storage["rouletteCaseKey"] = stateToStore
        
        let retrievedState: RouletteCase? = await rouletteCaseStore.get()
        XCTAssertEqual(retrievedState, stateToStore)
    }

    func testGetRouletteCase_Failure() async {
        mockStorageService.storage.removeValue(forKey: "rouletteCaseKey")

        let retrievedState: RouletteCase? = await rouletteCaseStore.get()
        XCTAssertNil(retrievedState)
    }

    func testDeleteRouletteCase_Success() async {
        let stateToStore = RouletteCase(prizeForDay: [0: .heart, 1: .fire, 2: .sunglasses])
        mockStorageService.storage["rouletteCaseKey"] = stateToStore
        
        await rouletteCaseStore.delete()
        
        XCTAssertNil(mockStorageService.storage["rouletteCaseKey"])
    }
    
}
