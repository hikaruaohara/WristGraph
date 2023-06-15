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

    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<graphViewModel.graphModel.weeks.count, id: \.self) { i in
                GridRow {
                    ForEach(0..<graphViewModel.graphModel.weeks[i].count, id: \.self) { j in
                        GraphElement(contributionLevel: graphViewModel.graphModel.weeks[i][j])
                            .aspectRatio(1, contentMode: .fit)
                    } 
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
