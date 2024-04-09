//
//  MainDebugView.swift
//  RouletteTestApp
//
//  Created by superuser on 4/8/24.
//

import SwiftUI

struct MainDebugView: View {
    
    @StateObject private var viewModel = MainDebugViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("День установки: \(viewModel.daysInstalled ?? 0)")
                    .padding()
                
                Button(action: {
                    Task {
                        await viewModel.startNextDay()
                    }
                }) {
                    Text("Начать следующий день")
                        .font(.title)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                
                Button(action: {
                    Task {
                        await viewModel.resetInstallation()
                    }
                }) {
                    Text("Сброс установки")
                        .font(.title)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                
                if viewModel.prizeTaken != nil {
                    Text("Забранный приз: \(viewModel.prizeTaken!.emoji())")
                        .padding()
                }
            }
            
            NavigationLink(
                destination: RouletteView(
                    viewModel: RouletteViewModel(
                        selectedPrize: viewModel.prizeToPlay ?? .heart, rouletteCase: viewModel.rouletteCase
                    )
                )
                .onDisappear() {
                    Task {
                        await viewModel.onAppear()
                    }
                }
                .navigationBarBackButtonHidden(true), isActive:  $viewModel.canPlayRoulette) {
                    EmptyView()
                }
                .disabled(true)
        }
        .onAppear() {
            Task {
                await viewModel.onAppear()
            }
        }
    }
    
}

#Preview {
    MainDebugView()
}
