//
//  UserStateStore.swift
//  RouletteTestApp
//
//  Created by superuser on 4/8/24.
//

import Foundation

final class UserStateStore: GenericStore<UserState> {
    
    //MARK: - Initialization
    
    init(storage: StorageService? = DependencySerivce.shared.resolve(StorageService.self)) {
        super.init(storage: storage, key: "userStateKey")
    }
    
    //MARK: - Methods
    
    func set(installDate: Date? = nil, daysInstalled: Int? = nil, prizeTaken: Int? = nil, updatePrize: Bool = false) async {
        guard var oldState = await get() else {
            let newState = UserState(
                installDate: installDate ?? Date(),
                daysInstalled: daysInstalled ?? 0,
                prizeTaken: prizeTaken
            )
            await add(newState)
            return
        }
        
        if let installDate, oldState.installDate != installDate {
            oldState.installDate = installDate
        }
        
        if let daysInstalled, oldState.daysInstalled != daysInstalled {
            oldState.daysInstalled = daysInstalled
        }
        
        if updatePrize, oldState.prizeTaken != prizeTaken {
            oldState.prizeTaken = prizeTaken
        }
        
        await update(oldState)
    }
    
}
