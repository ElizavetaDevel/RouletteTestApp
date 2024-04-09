//
//  RouletteTestsViewModel.swift
//  RouletteTestAppTests
//
//  Created by superuser on 4/10/24.
//

import XCTest
@testable import RouletteTestApp

class RouletteViewModelTests: XCTestCase {
    
    var userStateStore: UserStateStore!
    var viewModel: RouletteViewModel!
    var prize: Prize!
    
    override func setUp() {
        super.setUp()
        userStateStore = UserStateStore(storage: MockStorageService())
        prize = .sunglasses
        viewModel = RouletteViewModel(selectedPrize: prize, rouletteCase: RouletteCase(prizeForDay: [0: .heart, 1: .star, 2: .sunglasses]), userStateStore: userStateStore)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testPlay() {
        XCTAssertFalse(viewModel.spinning)
        XCTAssertFalse(viewModel.gamePlayed)
        let initialRotationDegrees = viewModel.rotationDegrees
        
        viewModel.play()
        
        XCTAssertTrue(viewModel.spinning)
        XCTAssertFalse(viewModel.gamePlayed)
        XCTAssertGreaterThan(viewModel.rotationDegrees, initialRotationDegrees)
    }
    
    func testGetPrize() async {
        await viewModel.getPrize()
        
        let user = await userStateStore.get()
        XCTAssertEqual(prize, Prize(rawValue: user!.prizeTaken!))
    }
    
    func testCheckIfRejectToShow() async {
        await userStateStore.set(daysInstalled: 0)
        let resultNoReject = await viewModel.checkIfRejectToShow()
        XCTAssertFalse(resultNoReject)
        
        await userStateStore.set(daysInstalled: 5)
        let resultReject = await viewModel.checkIfRejectToShow()
        XCTAssertTrue(resultReject)
    }
}
