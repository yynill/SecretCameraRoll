//
//  GrayButton.swift
//  SecretCameraRoll
//
//  Created by Yves Nill on 04.02.24.
//

import SwiftUI

struct GrayButton: View {
    let symbol: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .foregroundColor(Color.white.opacity(0.7))
                .frame(width: 80, height: 80)
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
    GrayButton(symbol: "percent")  {
        print("% Button tapped!")
    }
}
