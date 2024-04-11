//
//  SetPasswordView.swift
//  SecretCameraRoll
//
//  Created by Yves Nill on 04.02.24.
//

import SwiftUI

struct SetPasswordView: View {
    
    @State public var passwordInput: String = ""
    @Binding public var unlockPassword: String
    
    @Binding  public var passwordSheetActive: Bool
    @State private var isCopied: Bool = false
    
    @State private var buttonColorSet: Color = Color.white.opacity(0.1);
    @State private var buttonColorClear: Color = Color.white.opacity(0.1);
    
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ScrollView{
                VStack{
                    Spacer()
                    VStack{
                        HStack{
                            Text("Set Password")
                                .font(.title)
                            Spacer()
                            Button{
                                passwordSheetActive = false
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(Color(.label))
                                    .frame(width: 44, height: 44)
                            }
                        }
                        HStack{
                            Text("Current Password: " + unlockPassword)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    }
                    .padding(.top)
                    
                    VStack {
                        if isCopied {
                            Text("Copied!")
                                .foregroundColor(.green)
                        }
                        else{ Text(" ") }
                        Button(action: {
                            copyToClipboard()
                        }) {
                            TextField("42 + 69", text: $passwordInput)
                                .foregroundColor(.white)
                                .font(.system(size: 60, weight: .light))
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                                .multilineTextAlignment(.trailing)
                                .padding(.trailing, 40)
                                .padding(.leading, 20)
                                .disabled(true)
                        }
                        
                        // buttons ([AC], [+/-], [%], [/])
                        HStack {
                            DummyGrayButton(symbol: "AC", passwordInput: $passwordInput)
                            DummyGrayButton(symbol: "plus.forwardslash.minus", passwordInput: $passwordInput)
                            DummyGrayButton(symbol: "percent", passwordInput: $passwordInput)
                            DummySymbolButton(symbol: "divide", passwordInput: $passwordInput)
                        }
                        // buttons ([7], [8], [9], [*])
                        HStack {
                            DummyNumberButton(title: "7", passwordInput: $passwordInput)
                            DummyNumberButton(title: "8", passwordInput: $passwordInput)
                            DummyNumberButton(title: "9", passwordInput: $passwordInput)
                            DummySymbolButton(symbol: "multiply", passwordInput: $passwordInput)
                        }
                        
                        // buttons ([4], [5], [6], [-])
                        HStack {
                            DummyNumberButton(title: "4", passwordInput: $passwordInput)
                            DummyNumberButton(title: "5", passwordInput: $passwordInput)
                            DummyNumberButton(title: "6", passwordInput: $passwordInput)
                            DummySymbolButton(symbol: "minus", passwordInput: $passwordInput)
                        }
                        
                        // buttons ([1], [2], [3], [+])
                        HStack {
                            DummyNumberButton(title: "1", passwordInput: $passwordInput)
                            DummyNumberButton(title: "2", passwordInput: $passwordInput)
                            DummyNumberButton(title: "3", passwordInput: $passwordInput)
                            DummySymbolButton(symbol: "plus", passwordInput: $passwordInput)
                        }
                        
                        // buttons ([   0  ], [,], [=])
                        HStack {
                            DummyNumberButton(title: "0", passwordInput: $passwordInput)
                            DummyNumberButton(title: ",", passwordInput: $passwordInput)
                            DummySymbolButton(symbol: "equal", passwordInput: $passwordInput)
                        }.padding(.bottom, 10)
                    }
                    HStack{
                        StandartButton(btnText: "Clear / AC", color: buttonColorClear){
                            passwordInput = ""
                            withAnimation {
                                buttonColorClear = .red
                                buttonColorSet = Color.white.opacity(0.1)
                            }
                            // Reset button color to default after 1 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation {
                                    buttonColorClear = Color.white.opacity(0.1)
                                }
                            }
                        }
                        
                        StandartButton(btnText: "Set Password", color: buttonColorSet) {
                            unlockPassword = passwordInput
                            print(unlockPassword)
                            
                            withAnimation {
                                buttonColorSet = .green
                                buttonColorClear = Color.white.opacity(0.1)
                            }
                            
                            // Reset button color to default after 1 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation {
                                    buttonColorSet = Color.white.opacity(0.1)
                                    passwordSheetActive = false
                                }
                            }
                        }
                    }
                    .padding([.top, .bottom], 10)
                    Spacer()
                }
            }
        }
    }
    func copyToClipboard() {
            UIPasteboard.general.string = passwordInput
            isCopied = true

            // Reset the copied state after a brief delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isCopied = false
            }
        }

}

#Preview {
    SetPasswordView(unlockPassword: .constant(""), passwordSheetActive: .constant(false))
}
