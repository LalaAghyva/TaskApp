//
//  HomeAPIClientProtocol.swift
//  TaskApp
//
//  Created by Lala on 10.02.26.
//

import Foundation

protocol HomeAPIClientProtocol {
    func fetchHomeData() async throws -> [PageData]
}
