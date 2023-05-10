//
//  GraphElement.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/10.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex_ = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hex_)
        var rgbValue: UInt64 = 0

        if scanner.scanHexInt64(&rgbValue) {
            let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = Double(rgbValue & 0x0000FF) / 255.0

            self.init(red: red, green: green, blue: blue)
            return
        }

        self.init(red: 0, green: 0, blue: 0)
    }
}

struct GraphElement: View {
    private let color: Color

    init(color: String) {
        self.color = Color(hex: color)
    }

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .aspectRatio(1, contentMode: .fit)
        }
    }
}

struct GraphElement_Previews: PreviewProvider {
    static var previews: some View {
        GraphElement(color: "#9be9a8")
    }
}
