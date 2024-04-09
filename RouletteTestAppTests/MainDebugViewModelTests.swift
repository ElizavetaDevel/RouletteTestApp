//
//  MainDebugViewModelTests.swift
//  RouletteTestAppTests
//
//  Created by superuser on 4/10/24.
//

import XCTest
@testable import RouletteTestApp

class MainDebugViewModelTests: XCTestCase {
    
    var userStateStore: UserStateStore!
    var rouletteCaseStore: RouletteCaseStore!
    var viewModel: MainDebugViewModel!
    
    override func setUp() {
        super.setUp()
        userStateStore = UserStateStore(storage: MockStorageService())
        rouletteCaseStore = RouletteCaseStore(storage: MockStorageService())
        viewModel = MainDebugViewModel(userStateStore: userStateStore, rouletteCaseStore: rouletteCaseStore)
        
        let userState = UserState(installDate: Date(), daysInstalled: 0, prizeTaken: nil)
        Task {
            await userStateStore.add(userState)
        }
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testOnInit_RouletteCase() async {
        let rouletteCase = RouletteCase(prizeForDay: [0: .heart, 1: .star, 2: .sunglasses, 3: .fire])
        await rouletteCaseStore.add(rouletteCase)
        
        await viewModel.onInit()
        
        XCTAssertEqual(viewModel.rouletteCase, rouletteCase)
    }
    
    func testOnAppear_UserState() async {
        let newUserState = UserState(installDate: Date(), daysInstalled: 2, prizeTaken: nil)
        await userStateStore.update(newUserState)
        
        await viewModel.onAppear()
        
        XCTAssertEqual(viewModel.userState, newUserState)
        XCTAssertEqual(viewModel.daysInstalledState, newUserState.daysInstalled)
        XCTAssertFalse(viewModel.canPlayRoulette)
        XCTAssertNil(viewModel.prizeToPlay)
        XCTAssertNil(viewModel.prizeTaken)
    }
    
    func testStartNextDay() async {
        let newUserState = UserState(installDate: Date(), daysInstalled: 0, prizeTaken: nil)
        await userStateStore.update(newUserState)
        
        await viewModel.startNextDay()
        
        let userState = await userStateStore.get()
        
        XCTAssertNotNil(userState)
        XCTAssertEqual(userState!.daysInstalled, viewModel.daysInstalledState)
    }
    
    func testResetInstallation() async {
        await viewModel.resetInstallation()
        
        let userState = await userStateStore.get()
        
        XCTAssertNotNil(userState)

        XCTAssertEqual(viewModel.daysInstalledState, userState!.daysInstalled)
        XCTAssertNil(userState!.prizeTaken)
        XCTAssertNil(viewModel.prizeTakenState)
    }
    
    
    func testOnInit_NoRouletteCase() async {
        await rouletteCaseStore.delete()
        
        await viewModel.onInit()
        
        XCTAssertNil(viewModel.rouletteCase)
    }
}

