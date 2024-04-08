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
    
    let userStateStore = UserStateStore(storage: DependencySerivce.shared.resolve(StorageService.self))
    let rouletteCaseStore = RouletteCaseStore(storage: DependencySerivce.shared.resolve(StorageService.self))
    
    private(set) var rouletteCase: RouletteCase?
    private(set) var userState: UserState? {
        didSet {
            if let userState {
                DispatchQueue.main.async {
                    if userState.daysInstalled != self.installationDayCurrent {
                        self.installationDayCurrent = userState.daysInstalled
                    }
                    
                    if userState.prizeTaken != self.userStatePrize?.rawValue {
                        self.userStatePrize = userState.prizeTaken != nil ?
                        Prize(rawValue: userState.prizeTaken!) : nil
                    }
                }
            }
        }
    }
    
    private var installationDayCurrent: Int? {
        didSet {
            if let installationDayCurrent, let rouletteCase {
                DispatchQueue.main.async {
                    self.installationDay = installationDayCurrent
                    self.isNextDay = installationDayCurrent <= (rouletteCase.prizeForDay.count - 1)
                    self.prizeToPlay = rouletteCase.prizeForDay[installationDayCurrent]
                }
            }
        }
    }
    
    private var userStatePrize: Prize? {
        didSet {
            if let userStatePrize {
                DispatchQueue.main.async {
                    self.prizeTaken = userStatePrize
                }
            }
        }
    }
    
    @Published var installationDay: Int = 0
    @Published var isNextDay: Bool = false
    @Published var prizeToPlay: Prize?
    @Published var prizeTaken: Prize?
    
    //MARK: - Methods
    
    init() {
        Task {
            await onInit()
        }
    }
    
    func onInit() async {
        rouletteCase = await rouletteCaseStore.get()
    }
    
    func onAppear() async {
        userState = await userStateStore.get()
    }
    
    func startNextDay() async {
        installationDayCurrent = installationDay + 1
        await userStateStore.set(daysInstalled: installationDayCurrent)
    }
    
    func resetInstallation() async {
        installationDayCurrent = 0
        await userStateStore.set(installDate: Date(), daysInstalled: 0, prizeTaken: nil, updatePrize: true)
    }
    
}
