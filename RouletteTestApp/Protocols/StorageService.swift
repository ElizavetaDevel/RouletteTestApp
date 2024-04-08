//
//  StorageService.swift
//  roulette_test_app
//
//  Created by superuser on 4/8/24.
//

import Foundation

/// This is common storage interface.
/// For future StorageService can be replaced with implementation for any database

protocol StorageService {
    func add<T: Codable>(_ object: T, for key: String) async throws
    func get<T: Codable>(for key: String) async throws -> T?
    func update<T: Codable>(_ object: T, for key: String) async throws
    func delete(for key: String) async throws
}
