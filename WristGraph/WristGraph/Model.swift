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

    @Published var numOfCols: Int = 16
    @Published var followers: [String] = []
    @Published var graphViewModels: [GraphViewModel] = []

    init() {
        numOfCols = defaults.integer(forKey: "numOfCols")
        followers = defaults.stringArray(forKey: "followers") ?? []

        for follower in followers {
            graphViewModels.append(GraphViewModel(userName: follower))
        }
    }
}
