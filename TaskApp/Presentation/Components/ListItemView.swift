//
//  ListItemView.swift
//  Task
//
//  Created by Lala on 06.02.26.
//

import SwiftUI

struct ListItemView: View {

    let item: Item

    var body: some View {
        HStack(spacing: 12) {

            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 56, height: 56)
                .cornerRadius(8)
                .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title).font(.headline)
                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(AppColor.cellColor)
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

#Preview {
    ListItemView(item: Item(imageName: "nature_header", title: "Forest", subtitle: "Forest"))
}
