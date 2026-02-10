//
//  ImageCarouselView.swift
//  Task
//
//  Created by Lala on 06.02.26.
//

import SwiftUI

struct ImageCarouselView: View {
    
    let images: [String]
    @Binding var selectedIndex: Int

    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(images.indices, id: \.self) { index in
                Image(images[index])
                    .resizable()
                    .scaledToFill()
                    .frame(height: 240)
                    .cornerRadius(16)
                    .padding(.horizontal, 24)
                    .clipped()
                    .tag(index)
            }
        }
        .frame(height: 320)
        .tabViewStyle(.page)
    }
}

#Preview {
    ImageCarouselViewPreview()
}

private struct ImageCarouselViewPreview: View {
    @State private var selectedIndex = 1

    var body: some View {
        ImageCarouselView(
            images: [
                AppImage.Carousel.natureHeader,
                AppImage.Carousel.natureHeader,
                AppImage.Carousel.natureHeader,
            ],
            selectedIndex: $selectedIndex
        )
        .background(Color(.systemGray6))
    }
}
