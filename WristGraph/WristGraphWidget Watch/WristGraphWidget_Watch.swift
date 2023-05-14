//
//  WristGraphWidget_Watch.swift
//  WristGraphWidget Watch
//
//  Created by 青原光 on 2023/05/14.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct WristGraphWidget_WatchEntryView : View {
    var entry: Provider.Entry
    let numOfColumns = 19
    let levelDict = ["NONE", "FIRST_QUARTILE", "SECOND_QUARTILE", "THIRD_QUARTILE", "FOURTH_QUARTILE"]

    var body: some View {
        GeometryReader { geometry in
            let size = (geometry.size.height * 5 - 10) / 41
            VStack {
                Grid(horizontalSpacing: size / 5, verticalSpacing: size / 5) {
                    ForEach(0..<7, id: \.self) { i in
                        GridRow {
                            ForEach(0..<numOfColumns, id: \.self) { j in
                                let rand = Int.random(in: 0..<4)
                                GraphElement(contributionLevel: levelDict[rand], size: size)
                            }
                        }
                    }
                }
                .padding(.vertical, 1)
            }
        }
    }
}

struct WristGraphWidget_Watch: Widget {
    let kind: String = "WristGraphWidget_Watch"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WristGraphWidget_WatchEntryView(entry: entry)
        }
        .supportedFamilies([.accessoryRectangular])
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WristGraphWidget_Watch_Previews: PreviewProvider {
    static var previews: some View {
        WristGraphWidget_WatchEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
