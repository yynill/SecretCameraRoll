//
//  CalculatorView.swift
//  SecretCameraRoll
//
//  Created by Yves Nill on 04.02.24.
//

// to do
// "," and "+/-" logic implementatiom
// floats / double and big numbers not going of screen

import SwiftUI

struct CalculatorView: View {
    // Intro
    @State private var pageIndex = 0
    private let pages: [Page] = Page.samplePages
    private let dotAppearance = UIPageControl.appearance()
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true // Store in UserDefaults

    // password variables
    @State private var input: Double = 0
    @State private var savedInput: Double = 0
    
    @State public var acButton: String = "AC"
    @State public var calculationType: String = ""
    @State private var isFirstDigitAfterSymbol = true
    @State private var passwordSheetActive: Bool = false
    
    // Store password even when app closed
    @AppStorage("STRING_KEY") var unlockPassword: String = ""
    
    //@State private var unlockPassword: String = ""
    @State private var passwordChecker: String = ""
    @State public var isPasswordCorrect: Bool = false
        
    @StateObject private var selectionManager = ButtonSelectionManager()
    
    var body: some View {
        if isFirstLaunch {
            IntroView(isFirstLaunch: $isFirstLaunch)
        }
        else{
            NavigationView {
                
                ZStack {
                    NavigationLink(
                        destination: CamereRollView(isPasswordCorrect: $isPasswordCorrect).navigationBarBackButtonHidden(true),
                        isActive: $isPasswordCorrect,
                        label: {
                            Text("")
                                .hidden()
                        })
                    
                    Color.black.edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text(String(format: "%.12g", input))
                                .foregroundColor(.white)
                                .font(.system(size: 100, weight: .light))
                                .minimumScaleFactor(0.8)
                                .lineLimit(1)
                                .padding(10)
                        } // number row
                        
                        // buttons ([AC], [+/-], [%], [/])
                        HStack {
                            GrayButton(symbol: acButton) {
                                input = 0
                                savedInput = 0
                                acButton = "AC"
                                selectionManager.selectButton("")
                                passwordChecker = ""
                            }
                            GrayButton(symbol: "plus.forwardslash.minus") {
                                input = -1 * input
                                passwordChecker += "?"
                                checkPasswordCorrelation()
                            }
                            GrayButton(symbol: "percent")  {
                                print("% Button tapped!")
                                passwordChecker += "%"
                                checkPasswordCorrelation()
                            }
                            SymbolButton(symbol: "divide"){
                                //passwordChecker += "/"
                                checkPasswordCorrelation()
                            }
                            .environmentObject(selectionManager)
                        }
                        
                        // buttons ([7], [8], [9], [*])
                        HStack {
                            NumberButton(title: "7") {
                                addDigitToNumber(7)
                                passwordChecker += "7"
                                checkPasswordCorrelation()
                            }
                            NumberButton(title: "8") {
                                addDigitToNumber(8)
                                passwordChecker += "8"
                                checkPasswordCorrelation()
                            }
                            NumberButton(title: "9") {
                                addDigitToNumber(9)
                                passwordChecker += "9"
                                checkPasswordCorrelation()
                            }
                            SymbolButton(symbol: "multiply"){
                                passwordChecker += "*"
                                checkPasswordCorrelation()
                            }
                            .environmentObject(selectionManager)
                        }
                        
                        // buttons ([4], [5], [6], [-])
                        HStack {
                            NumberButton(title: "4") {
                                addDigitToNumber(4)
                                passwordChecker += "4"
                                checkPasswordCorrelation()
                            }
                            NumberButton(title: "5") {
                                addDigitToNumber(5)
                                passwordChecker += "5"
                                checkPasswordCorrelation()
                            }
                            NumberButton(title: "6") {
                                addDigitToNumber(6)
                                passwordChecker += "6"
                                checkPasswordCorrelation()
                            }
                            SymbolButton(symbol: "minus"){
                                passwordChecker += "-"
                                checkPasswordCorrelation()
                            }
                            .environmentObject(selectionManager)
                        }
                        
                        // buttons ([1], [2], [3], [+])
                        HStack {
                            NumberButton(title: "1") {
                                addDigitToNumber(1)
                                passwordChecker += "1"
                                checkPasswordCorrelation()
                            }
                            NumberButton(title: "2") {
                                addDigitToNumber(2)
                                passwordChecker += "2"
                                checkPasswordCorrelation()
                            }
                            NumberButton(title: "3") {
                                addDigitToNumber(3)
                                passwordChecker += "3"
                                checkPasswordCorrelation()
                            }
                            SymbolButton(symbol: "plus"){
                                passwordChecker += "+"
                                checkPasswordCorrelation()
                            }
                            .environmentObject(selectionManager)
                        }
                        
                        // buttons ([   0  ], [,], [=])
                        HStack {
                            NumberButton(title: "0") {
                                addDigitToNumber(0)
                                passwordChecker += "0"
                                checkPasswordCorrelation()
                            }
                            NumberButton(title: ",") {
                                addCommaToNumber()
                                passwordChecker += ","
                                checkPasswordCorrelation()
                            }
                            EqualButton(symbol: "equal", action: {
                                performCalculation()
                                passwordChecker += "="
                                checkPasswordCorrelation()
                            }, passwordSheetActive: $passwordSheetActive)
                            // long Tap
                            .simultaneousGesture(LongPressGesture(minimumDuration: 2.0).onEnded { _ in
                                passwordSheetActive.toggle()
                                generateHapticFeedback()
                            })
                            .sheet(isPresented: $passwordSheetActive, content: {
                                SetPasswordView(unlockPassword: $unlockPassword, passwordSheetActive: $passwordSheetActive)
                            })
                        }.padding(.bottom, 50)
                    }
                }
            }
        }
    }

    
    
    private func checkPasswordCorrelation() {
        print(passwordChecker)
        if passwordChecker == unlockPassword{
            print("unlock with password")
            isPasswordCorrect = true
        }
    }
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func addDigitToNumber(_ digit: Double) {
        calculationType = selectionManager.getCalculationType()
        acButton = "C"
        // Check if a symbol button was previously clicked
        
        if calculationType != "" {
            if isFirstDigitAfterSymbol {
                savedInput = input
                input = Double(digit)
                isFirstDigitAfterSymbol = false
            } else {
                input = input * 10 + Double(digit)
            }
        } else {
            input = input * 10 + digit
        }
    }
    
    func addCommaToNumber() {
        let numberString = String(format: "%.12g", input)
        
        // Check if the numberString already contains a comma
        if !numberString.contains(",") {
            input = Double(numberString + ",") ?? 0
        }
    }
    
    func performCalculation() {
        calculationType = selectionManager.getCalculationType()
        
        switch calculationType {
        case "plus":
            input = savedInput + input
        case "minus":
            input = savedInput - input
        case "multiply":
            input = savedInput * input
        case "divide":
            if input != 0 {
                input = savedInput / input
            }
        default:
            break
        }
        
        // Reset saved input and calculation type
        savedInput = 0
        selectionManager.selectButton("")
        isFirstDigitAfterSymbol = true
    }
    
    
    func incrementPage() {
            pageIndex += 1
        }
        
        func goToZero() {
            pageIndex = 0
        }
    
}


#Preview {
    CalculatorView()
}
