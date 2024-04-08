//
//  UserDefaultsServiceTests.swift
//  RouletteTestAppTests
//
//  Created by superuser on 4/8/24.
//

import XCTest
@testable import RouletteTestApp
import Swinject

class UserDefaultsServiceTests: XCTestCase {
    
    struct TestObject: Codable {
        var name: String
    }
    
    var container: Container!

    override func setUp() {
        super.setUp()
        container = Container()
        container.register(StorageService.self) { _ in
            UserDefaultsService(userDefaults: UserDefaults.standard)
        }
    }

    override func tearDown() {
        container = nil
        super.tearDown()
    }

    func testAdd() async {
        let service = container.resolve(StorageService.self)!
        
        let testName = "Test Add"
        let testKey = "testKeyAdd"
        
        let testAddObject = TestObject(name: testName)
        
        do {
            try await service.add(testAddObject, for: testKey)
        } catch {
            XCTFail("Add test: Failed to add object: \(error.localizedDescription)")
        }
    }

    func testGet() async {
        let service = container.resolve(StorageService.self)!
        
        let testName = "Test Get"
        let testKey = "testKeyGet"
        
        let testGetObject = TestObject(name: testName)
        
        do {
            try await service.add(testGetObject, for: testKey)
        } catch {
            XCTFail("Get test: Failed to add object: \(error.localizedDescription)")
        }
        
        do {
            try await service.add(testGetObject, for: testKey)
        } catch {
            XCTFail("Get test: Failed to add object: \(error.localizedDescription)")
        }
        
        do {
            let retrievedObject: TestObject? = try await service.get(for: testKey)
            XCTAssertEqual(retrievedObject?.name, testName, "Get test: Retrieved object's name does not match expected value")
        } catch {
            XCTFail("Get test: Failed to get object: \(error.localizedDescription)")
        }
    }

    func testUpdate() async {
        let service = container.resolve(StorageService.self)!
        
        let testName = "Test Update"
        let testKey = "testKeyUpdate"
        
        let testUpdateObject = TestObject(name: testName)
        
        do {
            try await service.add(testUpdateObject, for: testKey)
        } catch {
            XCTFail("Update test: Failed to add object: \(error.localizedDescription)")
        }
        
        var retrievedObject: TestObject?
        
        do {
            retrievedObject = try await service.get(for: testKey)
        } catch {
            XCTFail("Update test: Failed to get object: \(error.localizedDescription)")
        }
        
        let updatedName = "Updated Test"
        retrievedObject!.name = updatedName
        do {
            try await service.update(retrievedObject, for: testKey)
        } catch {
            XCTFail("Update test: Failed to update object: \(error.localizedDescription)")
        }
        
        do {
            let updatedObject: TestObject? = try await service.get(for: testKey)
            XCTAssertEqual(updatedObject?.name, updatedName, "Update test: Retrieved object's name does not match expected value")
        } catch {
            XCTFail("Update test: Failed to get updated object: \(error.localizedDescription)")
        }
    }

    func testDeleteMethod() async {
        let service = container.resolve(StorageService.self)!
        
        let testKey = "testKeyAdd"
        
        do {
            try await service.delete(for: testKey)
        } catch {
            XCTFail("Delete test: Failed to delete object: \(error.localizedDescription)")
        }
    }
    
}


