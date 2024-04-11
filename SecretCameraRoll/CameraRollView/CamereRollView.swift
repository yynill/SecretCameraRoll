//
//  CamereRollView.swift
//  SecretCameraRoll
//
//  Created by Yves Nill on 04.02.24.
//

import SwiftUI
import PhotosUI
import AVFoundation
import UIKit

struct MediaItem: Identifiable {
    let id = UUID()
    let type: MediaType
    let data: Data
    var isSelected = false
}

enum MediaType {
    case image(UIImage)
    case video(Data)
}

struct CamereRollView: View {
    @State public var selectedMedia: [MediaItem] = []
    @State public var photosPickerItems: [PhotosPickerItem] = []
        
    @Binding var isPasswordCorrect: Bool
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isSelectButtonSelected = false
    @State private var selectedFullScreenMedia: MediaItem?

    
    var body: some View {
        
        NavigationView {
            ZStack{
                ScrollView {
                    if !selectedMedia.isEmpty {
                        MediaGridView(selectedMedia: selectedMedia, selectedFullScreenMedia: $selectedFullScreenMedia, isSelectButtonSelected: $isSelectButtonSelected, onTapGesture: { mediaItem in
                            if !isSelectButtonSelected {
                            } else {
                                addToSelected(mediaItem: mediaItem)
                            }
                        })
                        MediaCountView(selectedMediaCount: selectedMedia.count)
                    } else {
                        EmptyStateView()
                    }

                }
                .interactiveDismissDisabled()
                .foregroundColor(.white)
                .navigationTitle("Media Gallery")
                .navigationBarItems(leading: leadingButtons, trailing: trailingButtons)
                
                .onChange(of: photosPickerItems) { _, _ in
                    Task {
                        for item in photosPickerItems {
                            if let data = try? await item.loadTransferable(type: Data.self) {
                                if let image = UIImage(data: data) {
                                    selectedMedia.append(MediaItem(type: .image(image), data: data))
                                } else {
                                    selectedMedia.append(MediaItem(type: .video(data), data: data))
                                }
                            }
                        }
                        photosPickerItems.removeAll()
                        saveMediaToUserDefaults()
                    }
                }
                .onAppear {
                    loadMediaFromUserDefaults()
                }
                if isSelectButtonSelected {
                    GeometryReader { geometry in
                        VStack(spacing: 100)  {
                            HStack {
                                CustomButton(action: {
                                    deleteSelected()
                                }, label: "Trash", systemImage: "trash", colorScheme: colorScheme)
                                .padding(.horizontal)
                                
                                CustomButton(action: {
                                    shareSelectedMedia()
                                }, label: "Share", systemImage: "square.and.arrow.up", colorScheme: colorScheme)
                                .padding(.horizontal)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(colorScheme == .dark ? 0.7 : 0.7))
                            .cornerRadius(30)
                            .zIndex(1)
                            .offset(x: geometry.size.width / 2 - 70, y: geometry.size.height * 0.9)
                        }
                    }
                }
            }
            .fullScreenCover(item: $selectedFullScreenMedia) { mediaItem in
                    FullScreenView(mediaItem: mediaItem, selectedFullScreenMedia: $selectedFullScreenMedia)
                
            }
        }
    }
    private var leadingButtons: some View {
        HStack {
            CustomButton(action: {
                isPasswordCorrect = false
            }, label: "Back", systemImage: "lock.open", colorScheme: colorScheme)
        }
    }
    
    private var trailingButtons: some View {
        HStack {
            // ... extract this part into a separate view or function ...
            CustomButton(action: {
                isSelectButtonSelected.toggle()
                for index in selectedMedia.indices {
                    selectedMedia[index].isSelected = false
                }
            }, label: "Select ", systemImage: nil, colorScheme: colorScheme)
            .frame(width: 60, height: 30)
            .padding(.trailing, 8)
            .background(isSelectButtonSelected ? Color.gray.opacity(0.3) : Color.clear)
            .cornerRadius(30)
            
            // ... extract this part into a separate view or function ...
            PhotosPicker(selection: $photosPickerItems, maxSelectionCount: 50, selectionBehavior: .ordered, matching: .not(.videos)) {
                Image(systemName: "plus.circle")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .imageScale(.large)
            }
        }
    }
    
    func shareSelectedMedia() {
        let selectedImages = selectedMedia.filter { $0.isSelected}
        
        guard !selectedImages.isEmpty else {
            return
        }
        
        var itemsToShare: [Any] = []
        
        for media in selectedImages {
           
                itemsToShare.append(media.data)
        }
        
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = UIApplication.shared.windows.first?.rootViewController?.view
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        }
        
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }

    func addToSelected(mediaItem: MediaItem) {
        if let index = selectedMedia.firstIndex(where: { $0.id == mediaItem.id }) {
            selectedMedia[index].isSelected.toggle()

        }
    }

    func deleteSelected() {
        selectedMedia.removeAll { $0.isSelected }
        saveMediaToUserDefaults()
    }
    
    func saveMediaToUserDefaults() {
        let mediaDataArray = selectedMedia.map { mediaItem in
            mediaItem.data
        }
        
        UserDefaults.standard.set(mediaDataArray, forKey: "selectedMedia")
    }
    
    func loadMediaFromUserDefaults() {
        if let mediaDataArray = UserDefaults.standard.array(forKey: "selectedMedia") as? [Data] {
            selectedMedia = mediaDataArray.compactMap { mediaData in
                if let image = UIImage(data: mediaData) {
                    return MediaItem(type: .image(image), data: mediaData)
                } else {
                    return MediaItem(type: .video(mediaData), data: mediaData)
                }
            }
        }
    }
}

struct MediaCountView: View {
    let selectedMediaCount: Int
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Text("\(selectedMediaCount) media items")
            .padding()
            .foregroundColor(colorScheme == .dark ? .white : .black)
    }
}

struct EmptyStateView: View {
    var body: some View {
        Text("Select an image by tapping on the import icon \n (videos not yet available)")
            .foregroundColor(.gray)
            .font(.system(size: 15))
            .bold()
            .multilineTextAlignment(.center)
            .frame(height: 600)
            .frame(maxWidth: .infinity)
        Spacer()
    }
}

struct MediaGridView: View {
    let selectedMedia: [MediaItem]
    @Binding var selectedFullScreenMedia: MediaItem?
    @Binding var isSelectButtonSelected: Bool
    let onTapGesture: (MediaItem) -> Void
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
            ForEach(selectedMedia) { mediaItem in
                MediaItemView(mediaItem: mediaItem, selectedFullScreenMedia: $selectedFullScreenMedia, isSelectButtonSelected: $isSelectButtonSelected, onTapGesture: {
                    onTapGesture(mediaItem)
                })
            }
        }
    }
}

struct MediaItemView: View {
    let mediaItem: MediaItem
        @Binding var selectedFullScreenMedia: MediaItem?
        @Binding var isSelectButtonSelected: Bool

        let onTapGesture: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            switch mediaItem.type {
            case .image(let image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: (geometry.size.width), height: (geometry.size.width))
                    .cornerRadius(5)
                    .padding(1)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .onTapGesture {
                        if !isSelectButtonSelected {
                                                    onTapGesture()
                                                    selectedFullScreenMedia = mediaItem
                                                } else {
                                                    onTapGesture() // Perform the selection action here
                                                }
                    }
                if mediaItem.isSelected {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.blue, lineWidth: 8)
                        .frame(width: (geometry.size.width), height: (geometry.size.width))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(1)
                }
            case .video(_):
                Text("Video")
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
}

#Preview {
    CamereRollView(isPasswordCorrect: .constant(true))
}
