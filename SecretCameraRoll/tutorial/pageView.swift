//
//  pageView.swift
//  SecretCameraRoll
//
//  Created by Yves Nill on 05.02.24.
//

import SwiftUI

struct PageView: View {
    var page: Page
    
    var body: some View {
        VStack(spacing: 10) {
            Image("\(page.imageUrl)")
                .resizable()
                .scaledToFit()
                .frame(height: 280)
                .padding()
                .cornerRadius(30)
                .background(.gray.opacity(0.20))
                .cornerRadius(10)
                .padding()
            
            Text(page.name)
                .font(.title)
                .multilineTextAlignment(.center) 
            Text(page.description)
                .font(.subheadline)
                .frame(width: 300)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    PageView(page: Page.samplePage)
}
