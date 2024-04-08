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
                            showRejectWarning = await viewModel.rejectPrize()
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
        .sheet(isPresented: $showRejectWarning, onDismiss: {
            if !viewModel.rejectSelected {
                Task {
                    await viewModel.getPrize()
                    presentationMode.wrappedValue.dismiss()
                }
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        }) {
            RejectModalView(viewModel: viewModel)
        }
    }
}

struct RejectModalView: View {
    @ObservedObject var viewModel: RouletteViewModel
    @Environment(\.presentationMode) var presentationMode : Binding<PresentationMode>
    
    var body: some View {
        VStack {
            Text("Отказаться от подарка навсегда?")
            Button("Да") {
                viewModel.rejectSelected = true
                presentationMode.wrappedValue.dismiss()
            }
            Button("Нет") {
                viewModel.rejectSelected = false
                presentationMode.wrappedValue.dismiss()
            }
        }
        .padding()
    }
}

#Preview {
    RouletteView(
        viewModel: RouletteViewModel(
            selectedPrize: .sunglasses, rouletteCase: RouletteCase(prizeForDay: [:])
        )
    )
}
