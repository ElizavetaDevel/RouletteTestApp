//
//  RouletteView.swift
//  RouletteTestApp
//
//  Created by superuser on 4/8/24.
//

import SwiftUI

struct RouletteView: View {
    
    @ObservedObject var viewModel: RouletteViewModel
    @Environment(\.presentationMode) var presentationMode : Binding<PresentationMode>
    
    @State var showRejectWarning = false
    
    init(viewModel: RouletteViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                PointerView()
                RouletteWheel(viewModel: viewModel)
                    .frame(width: 300, height: 300)
            }
            .padding(.bottom, 30)
            
            if !viewModel.gamePlayed {
                Button(action: {
                    self.viewModel.play()
                }) {
                    Text("Крутить")
                        .font(.title)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 50)
                .disabled(viewModel.spinning)
                .opacity(viewModel.spinning ? 0.5 : 1.0)
            } else {
                HStack {
                    Button(action: {
                        Task {
                            await viewModel.getPrize()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Забрать")
                            .font(.title)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        Task {
                            showRejectWarning = await viewModel.checkIfRejectToShow()
                            if !showRejectWarning {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }) {
                        Text("Отказаться")
                            .font(.title)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 50)
            }
            
            Spacer()
        }
        .alert(isPresented: $showRejectWarning) {
            Alert(
                title: Text("Отказаться от подарка навсегда?"),
                primaryButton: .default(Text("Да")) {
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel(Text("Нет")) {
                    Task {
                        await viewModel.getPrize()
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

#Preview {
    RouletteView(
        viewModel: RouletteViewModel(
            selectedPrize: .sunglasses, rouletteCase: RouletteCase(prizeForDay: [:])
        )
    )
}
