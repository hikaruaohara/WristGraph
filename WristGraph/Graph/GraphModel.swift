//
//  GraphModel.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/29.
//

import SwiftUI
import UIKit

struct GraphModel {
    var userName: String
    var weeks: [[String]]
    var graphFrame: CGSize {
        get {
            var newValue = CGSize()
            #if os(iOS)
            newValue.width = UIScreen.main.bounds.width
            #elseif os(watchOS)
            newValue.width = WKInterfaceDevice.current().screenBounds.width
            #endif

            newValue.height = newValue.width * 41 / (6 * CGFloat(model.numOfCols) - 1)

            return newValue
        }
    }

    @EnvironmentObject private var model: Model
}
