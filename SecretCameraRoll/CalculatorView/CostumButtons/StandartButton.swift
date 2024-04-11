//
//  StandartButton.swift
//  SecretCameraRoll
//
//  Created by Yves Nill on 04.02.24.
//

import SwiftUI

struct StandartButton: View {
    var btnText: String
    var color: Color
    var action: () -> Void
    
    var body: some View {
        HStack{
            Button(action: {
                self.action()
            }) {
                Text(btnText)
                    .bold()
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(color)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    StandartButton(btnText: "Print Action", color: .blue) {
                    print("Button pressed!")
                }
}
