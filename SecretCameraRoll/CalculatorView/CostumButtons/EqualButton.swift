//
//  EqualButton.swift
//  SecretCameraRoll
//
//  Created by Yves Nill on 04.02.24.
//

import SwiftUI

struct EqualButton: View {
    let symbol: String
    let action: () -> Void
    
    @Binding var passwordSheetActive: Bool
    @GestureState private var isLongPress: Bool = false
    
    var body: some View {
        let longPressedGesture = LongPressGesture(minimumDuration: 3.0)
            .updating($isLongPress) { value, state, transaction in
                state = value
            }
            .onEnded { _ in
                if isLongPress {
                    // Handle long press action
                    passwordSheetActive = true
                } else {
                    // Handle normal press action
                    action()
                }
            }
        
        return Button(action: {
            action()
        }) {
            Circle()
                .foregroundColor(.orange)
                .frame(width: 80, height: 80)
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
        .gesture(longPressedGesture)
    }
}


#Preview {
    EqualButton(symbol: "equal", action: {
        print("= button tapped")
    }, passwordSheetActive: .constant(false))
}
