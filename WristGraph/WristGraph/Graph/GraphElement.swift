//
//  GraphElement.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/10.
//

import SwiftUI

struct GraphElement: View {
    private let color: Color

    init(color: Color) {
        self.color = color
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(color)
            .aspectRatio(1, contentMode: .fit)
    }
}

struct GraphElement_Previews: PreviewProvider {
    static var previews: some View {
        GraphElement(color: Color.green)
    }
}
