//
//  NumberButton.swift
//  SecretCameraRoll
//
//  Created by Yves Nill on 04.02.24.
//

import SwiftUI

struct NumberButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            if title == "0" {
                RoundedRectangle(cornerRadius: 40)
                    .foregroundColor(Color.white.opacity(0.25))
                    .frame(width: 174, height: 80)
                    .padding(3)
                    .overlay(
                        Text(title)
                            .foregroundColor(.white)
                            .font(.system(size: 35, weight: .regular))
                            .padding(.trailing, 90)
                    )
            } else {
                Circle() // Use Circle for other buttons
                    .foregroundColor(Color.white.opacity(0.25))
                    .frame(width: 80, height: 80)
                    .padding(3)
                    .overlay(
                        Text(title)
                            .foregroundColor(.white)
                            .font(.system(size: 35, weight: .regular))
                    )
            }
        }
    }
}

#Preview {
    NumberButton(title: "3") {
        print("3 button tapped")
    }}
