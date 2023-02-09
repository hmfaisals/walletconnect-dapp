//
//  ContentView.swift
//  walletconnect-dapp-swiftui
//
//  Created by Faisal Saleem on 09/02/2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var model = QrCodeModel()
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 10) {
                Text("WalletConnect Dapp")
                    .foregroundColor(Color.white)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                ZStack {
                    
                    Image(uiImage: model.qrCodeCGImage == nil ? UIImage() : UIImage(cgImage: model.qrCodeCGImage))
                            .interpolation(.none)
                            .resizable()
                            .foregroundColor(Color.white)
                            .scaledToFill()
                }
                .frame(width: 260, height: 260)
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.clear))
                .overlay(
                    RoundedRectangle(cornerRadius: 17)
                        .stroke(Color.gray.opacity(0.6), style: StrokeStyle(lineWidth: 0.3))
                )
                .rotationEffect(.radians(.pi))
            }
            
            .onAppear {
                model.setupWalletConnect()
            }
        }
    }
}
