//
//  DummySymbolButton.swift
//  SecretCameraRoll
//
//  Created by Yves Nill on 04.02.24.
//

import SwiftUI

struct DummySymbolButton: View {
    let symbol: String
    @Binding var passwordInput: String

    var symbolDictionary = ["plus": "+", "minus": "-", "multiply": "*", "divide": "/", "equal": "="]
    
    var body: some View {
        Button {
            if let selectedSymbol = symbolDictionary[symbol] {
                passwordInput += selectedSymbol
            } else {}
        } label: {
            Circle()
                .foregroundColor(.orange )
                .frame(width: 70, height: 70)
                .padding(3)
                .overlay(
                    Group {
                        Image(systemName: symbol)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                            .font(Font.system(size: 35, weight: .semibold))
                    }
                )
        }
    }
}


#Preview {
    DummySymbolButton(symbol: "divide", passwordInput: .constant(" "))
}
