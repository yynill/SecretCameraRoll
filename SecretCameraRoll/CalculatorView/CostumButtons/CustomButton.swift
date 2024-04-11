//
//  CustomButton.swift
//  SecretCameraRoll
//
//  Created by Yves Nill on 04.02.24.
//

import SwiftUI

struct CustomButton: View {
    let action: () -> Void
    let label: String
    let systemImage: String?
    let colorScheme: ColorScheme
    
    var body: some View {
        Button(action: action) {
            if let systemImage = systemImage {
                Image(systemName: systemImage)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            } else {
                Text(label)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
        }
    }
}

#Preview {
    CustomButton(action: {
        print("costum buton tapped")
    }, label: "Trash", systemImage: "trash", colorScheme: .light)
}
