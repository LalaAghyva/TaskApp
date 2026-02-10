//
//  PageData.swift
//  Task
//
//  Created by Lala on 02.02.26.
//

import Foundation

struct PageData: Identifiable, Codable {
    let id = UUID()
    let imageName: String
    let items: [Item]
}
