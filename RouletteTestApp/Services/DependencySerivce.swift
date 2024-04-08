//
//  DependencyManager.swift
//  roulette_test_app
//
//  Created by superuser on 4/8/24.
//

import Foundation
import Swinject

final class DependencySerivce {
    
    //MARK: - Properties
    
    static let shared = DependencySerivce()

    private let container = Container()
    
    //MARK: - Initialization
    
    private init() {}
    
    //MARK: - Metods
    
    final func registerOnAppStart() {
        registerService(StorageService.self) { _ in
            UserDefaultsService()
        }
    }

    final func registerService<Service>(_ serviceType: Service.Type, factory: @escaping (Resolver) -> Service) {
        container.register(serviceType) { resolver in
            factory(resolver)
        }
        .inObjectScope(.container)
    }

    final func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return container.resolve(serviceType)
    }
    
}
