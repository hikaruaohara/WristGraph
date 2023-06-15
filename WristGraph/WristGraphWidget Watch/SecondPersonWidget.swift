//
//  SecondPersonWidget.swift
//  WristGraphWidget WatchExtension
//
//  Created by 青原光 on 2023/05/24.
//

import WidgetKit
import SwiftUI

struct SecondPersonWidgetProvider: TimelineProvider {
    private var demoWeeks = Array(repeating: [String](), count: 7)

    init() {
        let levels = ["NONE", "FIRST_QUARTILE", "SECOND_QUARTILE", "THIRD_QUARTILE", "FOURTH_QUARTILE"]

        for i in 0..<demoWeeks.count {
            for _ in 0..<19 {
                demoWeeks[i].append(levels[Int.random(in: 0..<levels.count)])
            }
        }
    }

    func placeholder(in context: Context) -> SecondPersonWidgetEntry {
        SecondPersonWidgetEntry(date: Date(), weeks: demoWeeks)
    }

    func getSnapshot(in context: Context, completion: @escaping (SecondPersonWidgetEntry) -> ()) {
        completion(SecondPersonWidgetEntry(date: Date(), weeks: demoWeeks))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            var entries: [SecondPersonWidgetEntry] = []

            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let weeks = await fetchData()
            let date = Calendar.current.date(byAdding: .hour, value: 0, to: Date())!
            entries.append(SecondPersonWidgetEntry(date: date, weeks: weeks))
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
                userName = followers[1]
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

struct SecondPersonWidgetEntry: TimelineEntry {
    var date: Date
    let weeks: [[String]]
}

struct SecondPersonWidgetEntryView : View {
    var entry: SecondPersonWidgetProvider.Entry

    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<entry.weeks.count, id: \.self) { i in
                GridRow {
                    ForEach(0..<entry.weeks[i].count, id: \.self) { j in
                        GraphElement(contributionLevel: entry.weeks[i][j])
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
        }
        .widgetAccentable()
    }
}

struct SecondPersonWidget: Widget {
    let kind: String = "SecondPersonWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SecondPersonWidgetProvider()) { entry in
            SecondPersonWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.accessoryRectangular])
        .configurationDisplayName("Second Person")
    }
}

struct SecondPersonWidget_Previews: PreviewProvider {
    static var previews: some View {
        SecondPersonWidgetEntryView(entry: SecondPersonWidgetEntry(date: Date(), weeks: [[String()]]))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
