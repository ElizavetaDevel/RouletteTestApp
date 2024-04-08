//
//  GenericStore.swift
//  RouletteTestApp
//
//  Created by superuser on 4/8/24.
//

import Foundation

import Foundation
import os.log

class GenericStore<T: Codable & Hashable> {
    
    //MARK: - Properties
    
    private let storage: StorageService?
    private let key: String
    private let logger = Logger()
    
    //MARK: - Initialization
    
    init(storage: StorageService?, key: String) {
        self.storage = storage
        self.key = key
    }
    
    //MARK: - Methods
    
    final func add(_ newValue: T) async {
        guard let storage = storage else {
            logger.error("Dependency for storage is not resolved")
            return
        }
        
        do {
            try await storage.add(newValue, for: key)
            logger.log("New value of \(T.self) stored successfully")
        } catch {
            logger.error("Error storing new value of \(T.self)")
        }
    }
    
    final func update(_ newValue: T) async {
        guard let storage = storage else {
            logger.error("Dependency for storage is not resolved")
            return
        }
        
        do {
            try await storage.update(newValue, for: key)
            logger.log("Updated \(T.self) value stored successfully")
        } catch {
            logger.error("Error storing updated value of \(T.self)")
        }
        
    }
    
    final func get() async -> T? {
        guard let storage = storage else {
            logger.error("Dependency for storage is not resolved")
            return nil
        }
        
        do {
            let value: T? = try await storage.get(for: key)
            logger.log("Fetched value of \(T.self): \(value.debugDescription)")
            return value
        } catch {
            logger.error("Error fetching value of \(T.self)")
            return nil
        }
    }
    
    final func delete() async {
        guard let storage = storage else {
            logger.error("Dependency for storage is not resolved")
            return
        }
        
        do {
            try await storage.delete(for: key)
            logger.log("Deleted value of \(T.self)")
        } catch {
            logger.error("Error deleting value of \(T.self)")
        }
    }
    
}
