//
//  GraphView.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/10.
//

import SwiftUI

struct GraphView: View {
    private let userName: String
    @State private var weeks = Array(repeating: [String](), count: 7)

    init(userName: String) {
        self.userName = userName
    }

    var body: some View {

        VStack {
            if (!weeks[0].isEmpty) {
                Grid(horizontalSpacing: 2, verticalSpacing: 2) {
                    ForEach(0..<weeks.count, id: \.self) { i in
                        GridRow {
                            ForEach(0..<weeks[i].count, id: \.self) { j in
                                GraphElement(contributionLevel: weeks[i][j])
                                    .frame(width: 18)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .task {
            do {
                weeks = Array(repeating: [String](), count: 7)
                let weeks_ = try await Request.shared.getGraph(userName: userName)
                let last20Weeks = weeks_[weeks_.count - 20 ..< weeks_.count]
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
        GraphView(userName: "dpgaspar")
    }
}
