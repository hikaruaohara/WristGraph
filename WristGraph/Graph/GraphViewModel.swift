//
//  GraphViewModel.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/28.
//

import SwiftUI
import UIKit

class GraphViewModel: ObservableObject {
    #if os(iOS)
    private let defaults = UserDefaults.standard
    #elseif os(watchOS)
    private let defaults = UserDefaults(suiteName: "group.com.hikaruaohara.WristGraph")!
    #endif

    var userName: String { graphModel.userName }
    var weeks: [[String]] { graphModel.weeks }
    var graphFrame: CGSize { graphModel.graphFrame }

    @Published var graphModel: GraphModel

    @EnvironmentObject private var model: Model

    init(userName: String) {
        graphModel = GraphModel(userName: userName, weeks: [[]])

        Task {
            await fetchData()
        }
    }

    func fetchData() async {
        graphModel.weeks = Array(repeating: [], count: 7)
        
        do {
            let weeks_ = try await Request.shared.getGraph(userName: graphModel.userName)
            let displayedWeeks = weeks_[weeks_.count - model.numOfCols ..< weeks_.count]

            for week in displayedWeeks {
                for day in week.contributionDays {
                    graphModel.weeks[day.weekday].append(day.contributionLevel)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
