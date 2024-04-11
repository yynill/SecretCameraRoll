//
//  TestView.swift
//  SecretCameraRoll
//
//  Created by Yves Nill on 05.02.24.
//

import SwiftUI

struct IntroView: View {
    @State private var pageIndex = 0
    private let pages: [Page] = Page.samplePages
    private let dotAppearance = UIPageControl.appearance()
    @Binding  var isFirstLaunch: Bool
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        TabView(selection: $pageIndex) {
            ForEach(pages) { page in
                VStack {
                    PageView(page: page)
                    Spacer()
                    if page == pages.last {
                        Button("Ready - Set - Hide!", action: goToZero)
                            .buttonStyle(.bordered)
                    } else {
                        Button("next", action: incrementPage)
                            .buttonStyle(.borderedProminent)
                    }
                    Spacer()
                }
                .tag(page.tag)
            }
        }
        .animation(.easeInOut, value: pageIndex)// 2
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        .tabViewStyle(PageTabViewStyle())
        .onAppear {
            dotAppearance.currentPageIndicatorTintColor = .orange
            dotAppearance.pageIndicatorTintColor = .gray
        }
    }
    
    func incrementPage() {
        pageIndex += 1
    }
    
    func goToZero() {
        isFirstLaunch = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView(isFirstLaunch: .constant(true))
    }
}
