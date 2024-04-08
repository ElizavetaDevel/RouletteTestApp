//
//  RouletteTestAppApp.swift
//  RouletteTestApp
//
//  Created by superuser on 4/8/24.
//

import SwiftUI
import os.log

@main
struct RouletteTestAppApp: App {
    
    let rouletteCaseStore: RouletteCaseStore
    let userStateStore: UserStateStore
    
    init() {
        DependencySerivce.shared.registerOnAppStart()
        
        rouletteCaseStore = RouletteCaseStore(storage: DependencySerivce.shared.resolve(StorageService.self))
        userStateStore = UserStateStore(storage: DependencySerivce.shared.resolve(StorageService.self))
        
        createRouletteCase()
        updateUserState()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    private func updateUserState() {
        Task {
            guard let userState =  await userStateStore.get() else {
                await userStateStore.add(UserState(installDate: Date(), daysInstalled: 0))
                return
            }
            
#if DEBUG
            Logger().log("Fetched user: \(userState.installDate) \(userState.daysInstalled) \(userState.prizeTaken ?? 0)")
            
#else
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: userState.installDate, to: Date())
            await userStateStore.set(daysInstalled: components.day)
#endif
        }
    }
    
    private func createRouletteCase() {
        Task {
            await rouletteCaseStore.add(RouletteCase(prizeForDay: [0: .heart, 1: .fire, 2: .sunglasses]))
        }
    }
    
}
