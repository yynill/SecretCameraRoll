//
//  DummyNumberButton.swift
//  SecretCameraRoll
//
//  Created by Yves Nill on 04.02.24.
//

import SwiftUI

struct DummyNumberButton: View {
    let title: String
    @Binding var passwordInput: String
    
    var body: some View {
        Button {
            passwordInput += title
        } label: {
            if title == "0" {
                RoundedRectangle(cornerRadius: 40)
                    .foregroundColor(Color.white.opacity(0.25))
                    .frame(width: 154, height: 70)
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
                    .frame(width: 70, height: 70)
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
    DummyNumberButton(title: "7", passwordInput: .constant(" "))
}
