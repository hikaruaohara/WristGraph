//
//  GraphView.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/10.
//

import SwiftUI
import UIKit

struct GraphView: View {
    let userName: String
    private let numOfColumns: Int
    @State private var graphFrame = (width: CGFloat(0), height: CGFloat(0))
    @State private var weeks = Array(repeating: [String](), count: 7)
    @State private var isLoading = true
    @Environment(\.scenePhase) private var scenePhase

    init(userName: String, numOfColumns: Int) {
        self.userName = userName

        if numOfColumns >= 2 && numOfColumns <= 53 {
            self.numOfColumns = numOfColumns
        } else {
            self.numOfColumns = 16
        }

        setFrame()
    }

    var body: some View {
        VStack {
            if (isLoading) {
                ProgressView()
            } else {
                let size = graphFrame.height * 5 / 41

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
        .frame(width: graphFrame.width, height: graphFrame.height)
        .onTapGesture {
            Task {
                await reload()
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                Task {
                    await reload()
                }
            }
        }
    }

    func reload() async {
        isLoading = true

        setFrame()
        await fetchData()

        isLoading = false
    }

    func setFrame() {
        #if os(iOS)
        graphFrame.width = UIScreen.main.bounds.width
        #elseif os(watchOS)
        graphFrame.width = WKInterfaceDevice.current().screenBounds.width
        #endif

        graphFrame.height = graphFrame.width * 41 / (6 * CGFloat(self.numOfColumns) - 1)
    }

    func fetchData() async {
        weeks = Array(repeating: [String](), count: 7)

        do {
            let weeks_ = try await Request.shared.getGraph(userName: userName)
            let displayedWeeks = weeks_[weeks_.count - numOfColumns ..< weeks_.count]
            for week in displayedWeeks {
                for day in week.contributionDays {
                    weeks[day.weekday].append(day.contributionLevel)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(userName: "hikaruaohara", numOfColumns: 16)
    }
}
