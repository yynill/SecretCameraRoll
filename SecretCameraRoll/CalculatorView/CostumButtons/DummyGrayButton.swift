//
//  DummyGrayButton.swift
//  SecretCameraRoll
//
//  Created by Yves Nill on 04.02.24.
//

import SwiftUI

struct DummyGrayButton: View {
    let symbol: String
    @Binding var passwordInput: String

    var symbolDictionary = ["AC": "A", "plus.forwardslash.minus": "?", "percent": "%"]
    
    var body: some View {
        Button {
            if let selectedSymbol = symbolDictionary[symbol] {
                if selectedSymbol == "A"{
                    passwordInput = ""
                }else {
                    passwordInput += selectedSymbol
                }
            }
        } label: {
            Circle()
                .foregroundColor(Color.white.opacity(0.7))
                .frame(width: 70, height: 70)
                .padding(3)
                .overlay(
                    Group {
                        if symbol == "AC" || symbol == "C" {
                            Text(symbol)
                                .foregroundColor(.black)
                                .font(.system(size: 35, weight: .regular))
                        } else {
                            Image(systemName: symbol)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundColor(.black)
                                .font(Font.system(size: 35, weight: .semibold))
                        }
                    }
                )
        }
    }
}

#Preview {
    DummyGrayButton(symbol: "percent", passwordInput: .constant(" "))
}
