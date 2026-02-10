//
//  HomeView.swift
//  Task
//
//  Created by Lala on 02.02.26.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - State
    @StateObject private var viewModel = HomeViewModel()
    @State private var showSheet = false
    
    // MARK: - Init
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .systemBlue
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.systemGray4
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            ScrollView {
                context
            }
            
            FloatingButton(isPresented: $showSheet)
        }
        .task {
            await viewModel.load()
        }
        .sheet(isPresented: $showSheet) {
            StatsSheetView(
                counts: viewModel.itemsCountPerPage(),
                top3: viewModel.top3Characters(),
                selectedIndex: viewModel.selectedPageIndex,
                visibleCount: viewModel.visibleItems.count
            )
        }
    }
}
    
private extension HomeView {
    
    var context: some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            
            ImageCarouselView(
                images: viewModel.pages.map { $0.imageName },
                selectedIndex: $viewModel.selectedPageIndex
            )
            .padding(.horizontal, 2)
            
            Section(header: searchHeader) {
                ForEach(viewModel.visibleItems) {
                    ListItemView(item: $0)
                }
            }
        }
    }
    
    var searchHeader: some View {
        VStack {
            HStack(spacing: 8) {
                Image(systemName: UIConstans.magnifyingGlass)
                    .foregroundStyle(.secondary)
                    .padding(.leading, 8)
                
                TextField(UIConstans.search, text: $viewModel.searchText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                if !viewModel.searchText.isEmpty {
                    clearButton
                }
            }
            .frame(height: 44)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .padding()
        }
        .background(Color(.systemBackground))
    }
    
    var clearButton: some View {
        Button {
            viewModel.searchText = ""
        } label: {
            Image(systemName: UIConstans.clear)
                .foregroundStyle(.secondary)
        }
        .padding(.trailing, 8)
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView()
}
