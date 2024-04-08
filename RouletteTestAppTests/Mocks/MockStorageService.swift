//
//  MockStorageService.swift
//  RouletteTestAppTests
//
//  Created by superuser on 4/8/24.
//

import Foundation
@testable import RouletteTestApp

class MockStorageService: StorageService {
    
    var storage: [String: Any] = [:]

    func add<T: Codable>(_ object: T, for key: String) async throws {
        storage[key] = object
    }

    func get<T: Codable>(for key: String) async throws -> T? {
        return storage[key] as? T
    }

    func update<T: Codable>(_ object: T, for key: String) async throws {
        guard storage[key] != nil else {
            throw NSError(domain: "MockStorageService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Object not found"])
        }
        storage[key] = object
    }
    
    func delete(for key: String) async throws {
        storage[key] = nil
    }
}
