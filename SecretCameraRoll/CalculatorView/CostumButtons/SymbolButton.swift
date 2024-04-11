//
//  SymbolButton.swift
//  SecretCameraRoll
//
//  Created by Yves Nill on 04.02.24.
//

import Foundation
import SwiftUI

// .orange
// Color.white.opacity(0.25)
// Color.white.opacity(0.7)

class ButtonSelectionManager: ObservableObject {
    @Published var selectedButton: String?
    
    func selectButton(_ symbol: String) {
        selectedButton = symbol
    }
    
    public func getCalculationType() -> String {
        
        switch selectedButton {
        case "equal":
            return "equal"
        case "plus":
            return "plus"
        case "minus":
            return "minus"
        case "divide":
            return "divide"
        case "multiply":
            return "multiply"
        default:
            return ""
        }
    }
    
}

struct SymbolButton: View {
    @EnvironmentObject var selectionManager: ButtonSelectionManager
    let symbol: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            selectionManager.selectButton(symbol)
            action()
        }) {
            Circle()
                .foregroundColor(selectionManager.selectedButton == symbol ? .white : .orange)
                .frame(width: 80, height: 80)
                .padding(3)
                .overlay(
                    Group {
                        Image(systemName: symbol)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(selectionManager.selectedButton == symbol ? .orange : .white)
                            .font(Font.system(size: 35, weight: .semibold))
                    }
                )
        }
    }
}
