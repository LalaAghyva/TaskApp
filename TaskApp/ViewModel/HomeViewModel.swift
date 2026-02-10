//
//  HomeViewModel.swift
//  TaskApp
//
//  Created by Lala on 10.02.26.
//

import Foundation

final class HomeViewModel {
    
    private let apiClient: HomeAPIClientProtocol

    private(set) var pages: [PageData] = []
    private(set) var selectedPageIndex: Int = 0
    private(set) var searchText: String = ""

    init(apiClient: HomeAPIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func load() async {
        //
        do {
            pages = try await apiClient.fetchHomeData()
        } catch {
            print("Failed to load data")
        }
    }
    
    var carouselImages: [String] {
        pages.map { $0.imageName }
    }

    // MARK: - Actions
    func setSelectedPage(index: Int) {
        selectedPageIndex = max(0, min(index, pages.count - 1))
    }

    func setSearchText(_ text: String) {
        searchText = text
    }

    // MARK: - Filtered items for current page
    var visibleItems: [Item] {
        guard pages.indices.contains(selectedPageIndex) else { return [] }
        let base = pages[selectedPageIndex].items

        let searchQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !searchQuery.isEmpty else { return base }

        return base.filter {
            return $0.title.contains(searchQuery) || $0.subtitle.contains(searchQuery)
        }
    }

    // MARK: - Stats (Bottom sheet)
    func itemsCountPerPage() -> [(pageIndex: Int, count: Int)] {
        pages.enumerated().map { (pageIndex: $0.offset, count: $0.element.items.count) }
    }

    //Top 3 chars from CURRENT list.
    func top3CharactersForSelectedPage(useFiltered: Bool) -> [(Character, Int)] {
        guard pages.indices.contains(selectedPageIndex) else { return [] }
        
        let source = useFiltered ? visibleItems : pages[selectedPageIndex].items

        let text = source
            .map { "\($0.title) \($0.subtitle)" }
            .joined(separator: " ")
            .lowercased()

        var characterFrequency: [Character: Int] = [:]
        for character in text {
            guard character.isLetter || character.isNumber else { continue }
            characterFrequency[character, default: 0] += 1
        }

        return characterFrequency
            .sorted { a, b in a.value == b.value ? a.key < b.key : a.value > b.value }
            .prefix(3)
            .map { ($0.key, $0.value) }
    }
    
    func prepareDataForSheet() -> (selected: String, counts: String, topChars: String) {
        let counts = itemsCountPerPage()
        let top3 = top3CharactersForSelectedPage(useFiltered: true)

        let selected =
            "Selected page: \(selectedPageIndex + 1)\n" +
            "Visible (filtered) items: \(visibleItems.count)"

        let countsText = counts
            .map { "List \($0.pageIndex + 1): \($0.count) items" }
            .joined(separator: "\n")

        let topCharsText = top3.isEmpty
            ? "Top 3 characters: (none)"
            : "Top 3 characters:\n" +
              top3.map { "• '\($0.0)' → \($0.1)" }.joined(separator: "\n")

        return (selected, countsText, topCharsText)
    }
}
