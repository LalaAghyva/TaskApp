//
//  PageData.swift
//  TaskApp
//
//  Created by Lala on 10.02.26.
//

import Foundation

struct PageData: Hashable {
    let id = UUID()
    let imageName: String
    let items: [Item]
}
