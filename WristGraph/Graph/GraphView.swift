//
//  GraphView.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/10.
//

import SwiftUI
import UIKit

struct GraphView: View {
    @State private var isLoading = false
    @ObservedObject var graphViewModel: GraphViewModel

    var body: some View {
        if isLoading {
            ProgressView()
        } else {
            Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                ForEach(0..<graphViewModel.weeks.count, id: \.self) { i in
                    GridRow {
                        ForEach(0..<graphViewModel.weeks[i].count, id: \.self) { j in
                            GraphElement(contributionLevel: graphViewModel.weeks[i][j])
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
            }
            .onTapGesture {
                Task {
                    isLoading = true
                    await graphViewModel.fetchData()
                    isLoading = false
                }
            }
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(graphViewModel: GraphViewModel(userName: "hikaruaohara"))
    }
}
