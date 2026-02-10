//
//  HomeAPIClient.swift
//  TaskApp
//
//  Created by Lala on 10.02.26.
//

import Foundation

final class HomeAPIClient: HomeAPIClientProtocol {

    func fetchHomeData() async throws -> [PageData] {
        // simulate network delay
        try await Task.sleep(nanoseconds: 700_000_000)

        return MockData.pages
    }
}
