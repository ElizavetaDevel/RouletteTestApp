//
//  RouletteViewModel.swift
//  RouletteTestApp
//
//  Created by superuser on 4/8/24.
//

import SwiftUI
import Combine

class RouletteViewModel: ObservableObject {
    
    //MARK: - Properties
    
    let userStateStore = UserStateStore(storage: DependencySerivce.shared.resolve(StorageService.self))
    
    let rouletteCase: RouletteCase?
    let prizes: [Prize] = Prize.allCases
    let selectedPrize: Prize
    let animationDuration: Int
    
    @Published var spinning = false
    @Published var gamePlayed = false
    @Published var rotationDegrees = 0.0
    @Published var rejectSelected = false
    
    //MARK: - Initialization
    
    init(selectedPrize: Prize, rouletteCase: RouletteCase?) {
        self.selectedPrize = selectedPrize
        self.rouletteCase = rouletteCase
        self.animationDuration = prizes.count + selectedPrize.rawValue
    }
    
    //MARK: - Metods
    
    func play() {
        guard !spinning && !gamePlayed else {
            return
        }
        
        spinning = true
        
        let degreesPerPrize = 360.0 / Double(self.prizes.count)
        let shift = (prizes.count - selectedPrize.rawValue + 3) % prizes.count
        let additionAngle = degreesPerPrize * Double(shift) + degreesPerPrize / 4
        
        rotationDegrees += Double(360 * (3 + selectedPrize.rawValue)) + additionAngle
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(animationDuration)) { [weak self] in
            self?.spinning = false
            self?.gamePlayed = true
        }
    }
    
    func getPrize() async {
        await userStateStore.set(prizeTaken: selectedPrize.rawValue, updatePrize: true)
    }
    
    func rejectPrize() async -> Bool {
        guard let userState = await userStateStore.get() else {
            return false
        }
        
        return userState.daysInstalled == (rouletteCase?.prizeForDay.count ?? 0) - 1
    }
    
}
