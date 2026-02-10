//
//  Item.swift
//  Task
//
//  Created by Lala on 06.02.26.
//

import Foundation

struct Item: Identifiable, Codable {
    let id = UUID()
    let imageName: String
    let title: String
    let subtitle: String
}
