//
//  Model.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/29.
//

import Foundation

class Model: ObservableObject {
    #if os(iOS)
    private let defaults = UserDefaults.standard
    #elseif os(watchOS)
    private let defaults = UserDefaults(suiteName: "group.com.hikaruaohara.WristGraph")!
    #endif

    @Published var numOfCols: Int
    @Published var followers: [String]

    init() {
        defaults.register(defaults: ["numOfCols": 16])
        numOfCols = defaults.integer(forKey: "numOfCols")
        followers = defaults.stringArray(forKey: "followers") ?? []
    }
}
