//
//  HomeViewModel .swift
//  Task
//
//  Created by Lala on 02.02.26.
//

import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {

    @Published private(set) var pages: [PageData] = []
    @Published var selectedPageIndex: Int = 0
    @Published var searchText: String = ""
    
    private let apiClient: HomeAPIClientProtocol

    init(apiClient: HomeAPIClientProtocol = HomeAPIClient()) {
        self.apiClient = apiClient
    }
    
    func load() async {
        do {
            pages = try await apiClient.fetchHomeData()
        } catch {
            print("Failed to load data")
        }
    }

    // MARK: - Filtered items for current page
    var visibleItems: [Item] {
        guard pages.indices.contains(selectedPageIndex) else { return [] }
        let base = pages[selectedPageIndex].items
        let searchQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !searchQuery.isEmpty else { return base }

        return base.filter {
            $0.title.localizedCaseInsensitiveContains(searchQuery) ||
            $0.subtitle.localizedCaseInsensitiveContains(searchQuery)
        }
    }

    // MARK: - Stats (Bottom sheet)
    func itemsCountPerPage() -> [(Int, Int)] {
        pages.enumerated().map { ($0.offset, $0.element.items.count) }
    }

    // TOP 3 chars → visible (filtered) list
    func top3Characters() -> [(Character, Int)] {
        let text = visibleItems
            .map { "\($0.title) \($0.subtitle)" }
            .joined(separator: " ")
            .lowercased()
            .filter { $0.isLetter }

        var characterFrequency: [Character: Int] = [:]
        for character in text { characterFrequency[character, default: 0] += 1 }

        return characterFrequency
            .sorted { $0.value > $1.value }
            .prefix(3)
            .map { ($0.key, $0.value) }
    }
}
