//
//  FullScreenView.swift
//  HiddenCalculator
//
//  Created by Yves Nill on 05.02.24.
// 

import SwiftUI
import AVKit

struct FullScreenView: View {
    let mediaItem: MediaItem
    
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedFullScreenMedia: MediaItem?

    
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var previousScale: CGFloat = 1.0
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        NavigationView {
            ZStack {
                
                switch mediaItem.type {
                case .image(let image):
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(colorScheme == .dark ? Color.black : Color.white)
                        .padding(.top, 70)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    let newScale = previousScale * value
                                    // Restrict the zoom out to the original image size
                                    if newScale >= 1.0 {
                                        scale = newScale
                                    }
                                    
                                    // Reset the offset if the scale is 1.0
                                    if scale <= 1.1 {
                                        offset.width = 0
                                        offset.height = 0
                                        
                                    }
                                }
                                .onEnded { value in
                                    previousScale = scale
                                }
                        )
                        .simultaneousGesture(
                            DragGesture()
                                .onChanged { value in
                                    let dragTranslation = value.translation
                                    // Convert the drag offset to the image coordinate space
                                    let convertedDragOffset = CGSize(
                                        width: dragTranslation.width * scale,
                                        height: dragTranslation.height * scale
                                    )
                                    // Update the offset based on the drag gesture
                                    if scale > 1.1 {
                                        offset.width += convertedDragOffset.width
                                        offset.height += convertedDragOffset.height
                                    }
                                    // else logic for swiping to a different image.
                                    print("scale: \(scale)")
                                    print("Offset: \(offset)")
                                    
                                }
                                .onEnded { value in
                                    // Handle the end of the drag gesture if needed
                                }
                        )
                        .scaleEffect(scale)
                        .offset(offset)
                        .onAppear {
                        }
                    
                case .video(_):
                    Text("video preview")
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        CustomButton(action: {
                            // Implement the logic for the Back button here
                            selectedFullScreenMedia = nil
                        }, label: "Back", systemImage: "chevron.backward", colorScheme: colorScheme)
                        
                        Spacer()
                        
                        // future feature
                        
                        //CustomButton(action: {
                        //}, label: "Trash", systemImage: "trash", colorScheme: colorScheme)
                        
                        //CustomButton(action: {
                        //}, label: "Share", systemImage: "square.and.arrow.up", colorScheme: colorScheme)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(colorScheme == .dark ? 0.4 : 0.2))
                    .cornerRadius(30)
                    .zIndex(1)
                    .offset(y: -20)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                // Implement logic to close the sheet when dragging on the navigation bar
                                let dragLocation = value.location
                                if dragLocation.y < 100 {
                                    selectedFullScreenMedia = nil
                                }
                            }
                            .onEnded { value in
                                // Handle the end of the drag gesture if needed
                            }
                    )
                    Spacer()
                }
                .padding(.horizontal,10)
                .padding( .top, 30)
                
            }
            .background(colorScheme == .dark ? Color.black : Color.white) // Adjust the background color based on colorScheme
            .navigationBarHidden(true)
        }
    }
}
