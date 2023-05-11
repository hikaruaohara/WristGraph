//
//  GraphView.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/10.
//

import SwiftUI

struct GraphView: View {
    private let userName: String
    private let numOfColumns = 16
    @State private var weeks = Array(repeating: [String](), count: 7)

    init(userName: String) {
        self.userName = userName
    }

    var body: some View {
        VStack {
            if (!weeks[0].isEmpty) {
                GeometryReader { geometry in
                    let size = geometry.size.width * 5 / (6 * CGFloat(numOfColumns) - 1)

                    Grid(horizontalSpacing: size / 5, verticalSpacing: size / 5) {
                        ForEach(0..<weeks.count, id: \.self) { i in
                            GridRow {
                                ForEach(0..<weeks[i].count, id: \.self) { j in
                                    GraphElement(contributionLevel: weeks[i][j], size: size)
                                }
                            }
                        }
                    }
                }
            }
        }
        .task {
            weeks = Array(repeating: [String](), count: 7)

            do {
                let weeks_ = try await Request.shared.getGraph(userName: userName)
                let last20Weeks = weeks_[weeks_.count - numOfColumns ..< weeks_.count]
                for week in last20Weeks {
                    for day in week.contributionDays {
                        weeks[day.weekday].append(day.contributionLevel)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(userName: "hikaruaohara")
    }
}
