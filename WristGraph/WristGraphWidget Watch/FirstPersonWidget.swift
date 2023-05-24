//
//  FirstPersonWidget.swift
//  WristGraphWidget Watch
//
//  Created by 青原光 on 2023/05/14.
//

import WidgetKit
import SwiftUI

struct FirstPersonWidgetProvider: TimelineProvider {
    private var demoWeeks = Array(repeating: [String](), count: 7)

    init() {
        let levels = ["NONE", "FIRST_QUARTILE", "SECOND_QUARTILE", "THIRD_QUARTILE", "FOURTH_QUARTILE"]

        for i in 0..<demoWeeks.count {
            for _ in 0..<19 {
                demoWeeks[i].append(levels[Int.random(in: 0..<levels.count)])
            }
        }
    }

    func placeholder(in context: Context) -> FirstPersonWidgetEntry {
        FirstPersonWidgetEntry(date: Date(), weeks: demoWeeks)
    }

    func getSnapshot(in context: Context, completion: @escaping (FirstPersonWidgetEntry) -> ()) {
        completion(FirstPersonWidgetEntry(date: Date(), weeks: demoWeeks))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            var entries: [FirstPersonWidgetEntry] = []

            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let weeks = await fetchData()
            let date = Calendar.current.date(byAdding: .hour, value: 0, to: Date())!
            entries.append(FirstPersonWidgetEntry(date: date, weeks: weeks))
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }

    func fetchData() async -> [[String]] {
        let sharedUserDefaults = UserDefaults(suiteName: "group.com.hikaruaohara.WristGraph")!
        var weeks = Array(repeating: [String](), count: 7)

        do {
            var userName = ""
            if let followers = sharedUserDefaults.stringArray(forKey: "followers") {
                userName = followers[0]
            }
            let weeks_ = try await Request.shared.getGraph(userName: userName)
            let displayedWeeks = weeks_[weeks_.count - 19 ..< weeks_.count]
            for week in displayedWeeks {
                for day in week.contributionDays {
                    weeks[day.weekday].append(day.contributionLevel)
                }
            }
        } catch {
            print(error.localizedDescription)
        }

        return weeks
    }
}

struct FirstPersonWidgetEntry: TimelineEntry {
    var date: Date
    let weeks: [[String]]
}

struct FirstPersonWidgetEntryView : View {
    var entry: FirstPersonWidgetProvider.Entry

    var body: some View {
        GeometryReader { geometry in
            let size = (geometry.size.height * 5 - 10) / 41

            Grid(horizontalSpacing: size / 5, verticalSpacing: size / 5) {
                ForEach(0..<entry.weeks.count, id: \.self) { i in
                    GridRow {
                        ForEach(0..<entry.weeks[i].count, id: \.self) { j in
                            GraphElement(contributionLevel: entry.weeks[i][j], size: size)
                        }
                    }
                }
            }
            .widgetAccentable()
        }
    }
}

struct FirstPersonWidget: Widget {
    let kind: String = "FirstPersonWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FirstPersonWidgetProvider()) { entry in
            FirstPersonWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.accessoryRectangular])
        .configurationDisplayName("First Person")
    }
}

struct FirstPersonWidget_Previews: PreviewProvider {
    static var previews: some View {
        FirstPersonWidgetEntryView(entry: FirstPersonWidgetEntry(date: Date(), weeks: [[String()]]))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
