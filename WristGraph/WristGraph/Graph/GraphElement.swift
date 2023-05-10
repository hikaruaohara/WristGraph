//
//  GraphElement.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/10.
//

import SwiftUI

struct GraphElement: View {
    private let color: Color

    init(contributionLevel: String) {
        switch contributionLevel {
        case "FIRST_QUARTILE":
            color = Color.green.opacity(0.25)
        case "SECOND_QUARTILE":
            color = Color.green.opacity(0.5)
        case "THIRD_QUARTILE":
            color = Color.green.opacity(0.75)
        case "FOURTH_QUARTILE":
            color = Color.green.opacity(1)
        default:
            color = Color.gray.opacity(0.2)
        }
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(color)
            .aspectRatio(1, contentMode: .fit)
    }
}

struct GraphElement_Previews: PreviewProvider {
    static var previews: some View {
        GraphElement(contributionLevel: "SECOND_QUARTILE")
    }
}
