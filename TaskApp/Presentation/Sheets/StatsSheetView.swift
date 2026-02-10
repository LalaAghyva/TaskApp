//
//  StatsSheetView.swift
//  Task
//
//  Created by Lala on 06.02.26.
//

import SwiftUI

struct StatsSheetView: View {

    let counts: [(Int, Int)]
    let top3: [(Character, Int)]
    let selectedIndex: Int
    let visibleCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text("Statistics")
                .font(.system(size: 24, weight: .bold, design: .default))

            Text("Selected page: \(selectedIndex + 1)")
            Text("Visible (filtered) items: \(visibleCount)")

            Divider()
                .padding(4)

            ForEach(counts, id: \.0) {
                Text("List \($0.0 + 1): \($0.1) items")
            }

            Divider()

            Text("Top 3 characters:")
            ForEach(top3, id: \.0) {
                Text("·'\(String($0.0))' → \($0.1)")
            }

            Spacer()
        }
        .font(.system(size: 20))
        .padding()
        .presentationDetents([.medium, .large])
    }
}
