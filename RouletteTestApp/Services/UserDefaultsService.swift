//
//  UserDefaultsService.swift
//  roulette_test_app
//
//  Created by superuser on 4/8/24.
//

import Foundation

final class UserDefaultsService: StorageService {
    
    //MARK: - Properties
    
    let userDefaults: UserDefaults
    
    //MARK: - Initialization
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    //MARK: - Metods
    
    final func add<T: Codable>(_ object: T, for key: String) async throws {
        do {
            let data = try JSONEncoder().encode(object)
            userDefaults.set(data, forKey: key)
        } catch {
            throw error
        }
    }
    
    final func get<T: Codable>(for key: String) async throws -> T? {
        if let data = userDefaults.data(forKey: key) {
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                return object
            } catch {
                throw error
            }
        }
        return nil
    }
    
    final func update<T: Codable>(_ object: T, for key: String) async throws {
        do {
            let data = try JSONEncoder().encode(object)
            userDefaults.set(data, forKey: key)
        } catch {
            throw error
        }
    }
    
    final func delete(for key: String) async throws {
        userDefaults.removeObject(forKey: key)
    }
    
}
