//
//  GraphView.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/10.
//

import SwiftUI
import UIKit

struct GraphView: View {
    @ObservedObject var graphViewModel: GraphViewModel
    @EnvironmentObject private var model: Model

    var body: some View {
        VStack(alignment: .leading) {
            Text(graphViewModel.userName)
                .bold()

            let size = graphViewModel.graphFrame.height * 5 / 41
            Grid(horizontalSpacing: size / 5, verticalSpacing: size / 5) {
                ForEach(0..<graphViewModel.weeks.count, id: \.self) { i in
                    GridRow {
                        ForEach(0..<graphViewModel.weeks[i].count, id: \.self) { j in
                            GraphElement(contributionLevel: graphViewModel.weeks[i][j], size: size)
                        }
                    }
                }
            }
        }
        .frame(width: graphViewModel.graphFrame.width, height: graphViewModel.graphFrame.height)
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(graphViewModel: GraphViewModel(userName: "hikaruaohara"))
    }
}
