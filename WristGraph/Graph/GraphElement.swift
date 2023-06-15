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
            color = Color.green.opacity(0.4)
        case "SECOND_QUARTILE":
            color = Color.green.opacity(0.6)
        case "THIRD_QUARTILE":
            color = Color.green.opacity(0.8)
        case "FOURTH_QUARTILE":
            color = Color.green.opacity(1)
        default:
            color = Color.gray.opacity(0.2)
        }
    }

    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: geometry.size.width / 5)
                .fill(color)
                .padding(.all, geometry.size.width / 10)
        }
    }
}

struct GraphElement_Previews: PreviewProvider {
    static var previews: some View {
        GraphElement(contributionLevel: "SECOND_QUARTILE")
    }
}
