//
//  UserStateStoreTests.swift
//  RouletteTestAppTests
//
//  Created by superuser on 4/8/24.
//

import XCTest
@testable import RouletteTestApp

class UserStateStoreTests: XCTestCase {
    
    var userStateStore: UserStateStore!
    var mockStorageService: MockStorageService!

    override func setUp() {
        super.setUp()
        mockStorageService = MockStorageService()
        userStateStore = UserStateStore(storage: mockStorageService)
    }

    override func tearDown() {
        userStateStore = nil
        mockStorageService = nil
        super.tearDown()
    }

    func testAddUserState_NewState() async {
        let newState = UserState(installDate: Date(), daysInstalled: 0, prizeTaken: Prize.heart.rawValue)

        await userStateStore.add(newState)

        XCTAssertNotNil(mockStorageService.storage["userStateKey"])
        XCTAssertEqual(mockStorageService.storage["userStateKey"] as? UserState, newState)
    }

    func testUpdateUserState_ExistingState() async {
        let existingState = UserState(installDate: Date(), daysInstalled: 0, prizeTaken: Prize.heart.rawValue)
        mockStorageService.storage["userStateKey"] = existingState

        let newState = UserState(installDate: Date(), daysInstalled: 0, prizeTaken: Prize.heart.rawValue)
        await userStateStore.update(newState)
        
        XCTAssertEqual(mockStorageService.storage["userStateKey"] as? UserState, newState)
    }

    func testGetUserState_Success() async {
        let stateToStore = UserState(installDate: Date(), daysInstalled: 0, prizeTaken: Prize.heart.rawValue)
        mockStorageService.storage["userStateKey"] = stateToStore
        
        let retrievedState: UserState? = await userStateStore.get()
        XCTAssertEqual(retrievedState, stateToStore)
    }

    func testGetUserState_Failure() async {
        mockStorageService.storage.removeValue(forKey: "userStateKey")

        let retrievedState: UserState? = await userStateStore.get()
        XCTAssertNil(retrievedState)
    }

    func testDeleteUserState_Success() async {
        let stateToStore = UserState(installDate: Date(), daysInstalled: 0, prizeTaken: Prize.heart.rawValue)
        mockStorageService.storage["userStateKey"] = stateToStore
        
        await userStateStore.delete()
        
        XCTAssertNil(mockStorageService.storage["userStateKey"])
    }
    
    func testSet_WithNewState() async {
        let newState = UserState(installDate: Date(), daysInstalled: 0, prizeTaken: Prize.heart.rawValue)
        
        await userStateStore.set(installDate: newState.installDate, daysInstalled: newState.daysInstalled, prizeTaken: newState.prizeTaken)
        
        XCTAssertEqual(mockStorageService.storage["userStateKey"] as? UserState, newState)
    }

    func testSet_WithExistingState() async {
        let existingState = UserState(installDate: Date(), daysInstalled: 0, prizeTaken: Prize.heart.rawValue)
        mockStorageService.storage["userStateKey"] = existingState
        
        let newInstallDate = Date()
        let newDaysInstalled = 5
        let newPrizeTaken = Prize.fire.rawValue
        
        await userStateStore.set(installDate: newInstallDate, daysInstalled: newDaysInstalled, prizeTaken: newPrizeTaken)
        
        XCTAssertEqual(mockStorageService.storage["userStateKey"] as? UserState,
                       UserState(installDate: newInstallDate, daysInstalled: newDaysInstalled, prizeTaken: newPrizeTaken))
    }
    
    func testSet_ResetPrize() async {
        let existingState = UserState(installDate: Date(), daysInstalled: 5, prizeTaken: Prize.heart.rawValue)
        mockStorageService.storage["userStateKey"] = existingState
        
        let newInstallDate = Date()
        let newDaysInstalled = 5
        let newPrizeTaken: Int? = nil
        
        await userStateStore.set(installDate: newInstallDate, daysInstalled: newDaysInstalled, prizeTaken: newPrizeTaken)
        
        XCTAssertEqual(mockStorageService.storage["userStateKey"] as? UserState,
                       UserState(installDate: newInstallDate, daysInstalled: newDaysInstalled, prizeTaken: newPrizeTaken))
    }

}
