//
//  RouletteCaseStore.swift
//  RouletteTestApp
//
//  Created by superroulette case on 4/8/24.
//

import Foundation

final class RouletteCaseStore: GenericStore<RouletteCase> {
    
    //MARK: - Initialization
    
    init(storage: StorageService? = DependencySerivce.shared.resolve(StorageService.self)) {
        super.init(storage: storage, key: "rouletteCaseKey")
    }
    
}
