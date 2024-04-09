//
//  MainDebugViewModel.swift
//  RouletteTestApp
//
//  Created by superuser on 4/8/24.
//

import Foundation
import Combine
import SwiftUI

class MainDebugViewModel: ObservableObject {
    
    //MARK: - Properties
    
    let userStateStore: UserStateStore
    let rouletteCaseStore: RouletteCaseStore
    
    private(set) var rouletteCase: RouletteCase?
    private(set) var userState: UserState? {
        didSet {
            if let userState {
                DispatchQueue.main.async {
                    if userState.daysInstalled != self.daysInstalledState {
                        self.daysInstalledState = userState.daysInstalled
                    }
                    
                    if userState.prizeTaken != self.prizeTakenState?.rawValue {
                        self.prizeTakenState = userState.prizeTaken != nil ?
                        Prize(rawValue: userState.prizeTaken!) : nil
                    }
                }
            }
        }
    }
    
    private(set) var daysInstalledState: Int? {
        didSet {
            if let daysInstalledState, let rouletteCase {
                DispatchQueue.main.async {
                    self.daysInstalled = daysInstalledState
                    self.canPlayRoulette = daysInstalledState <= (rouletteCase.prizeForDay.count - 1)
                    self.prizeToPlay = rouletteCase.prizeForDay[daysInstalledState]
                }
            }
        }
    }
    
    private(set) var prizeTakenState: Prize? {
        didSet {
            if let prizeTakenState {
                DispatchQueue.main.async {
                    self.prizeTaken = prizeTakenState
                }
            }
        }
    }
    
    @Published var canPlayRoulette: Bool = false
    @Published var prizeToPlay: Prize?
    
    @Published var daysInstalled: Int = 0
    @Published var prizeTaken: Prize?
    
    //MARK: - Methods
    
    init(userStateStore: UserStateStore = UserStateStore(),
         rouletteCaseStore: RouletteCaseStore = RouletteCaseStore()) {
        self.userStateStore = userStateStore
        self.rouletteCaseStore = rouletteCaseStore
        
        Task {
            await onInit()
        }
    }
    
    func onInit() async {
        rouletteCase = await rouletteCaseStore.get()
    }
    
    func onAppear() async {
        userState = await userStateStore.get()
        daysInstalledState = userState?.daysInstalled
        prizeTakenState = userState?.prizeTaken != nil ? Prize(rawValue: userState!.prizeTaken!) : nil
    }
    
    func startNextDay() async {
        daysInstalledState = daysInstalled + 1
        await userStateStore.set(daysInstalled: daysInstalledState)
    }
    
    func resetInstallation() async {
        daysInstalledState = 0
        await userStateStore.set(installDate: Date(), daysInstalled: 0, prizeTaken: nil, updatePrize: true)
    }
    
}
