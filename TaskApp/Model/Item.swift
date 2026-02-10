//
//  Item.swift
//  TaskApp
//
//  Created by Lala on 10.02.26.
//

import Foundation

struct Item: Hashable {
    let id = UUID()
    let imageName: String
    let title: String
    let subtitle: String
}
