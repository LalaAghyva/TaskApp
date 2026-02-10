//
//  FloatingButton.swift
//  Task
//
//  Created by Lala on 06.02.26.
//

import SwiftUI

struct FloatingButton: View {

    @Binding var isPresented: Bool

    var body: some View {
        Button {
            isPresented = true
        } label: {
            Image(systemName: UIConstans.ellipsis)
                .rotationEffect(.init(degrees: 90))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color.blue)
                .clipShape(Circle())
                .shadow(radius: 10, y: 6)
        }
        .padding()
    }
}
