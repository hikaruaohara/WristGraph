//
//  WristGraphWidget_Watch.swift
//  WristGraphWidget Watch
//
//  Created by 青原光 on 2023/05/14.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    private var demoWeeks = Array(repeating: [String](), count: 7)

    init() {
        let levels = ["NONE", "FIRST_QUARTILE", "SECOND_QUARTILE", "THIRD_QUARTILE", "FOURTH_QUARTILE"]

        for i in 0..<demoWeeks.count {
            for _ in 0..<19 {
                demoWeeks[i].append(levels[Int.random(in: 0..<levels.count)])
            }
        }
    }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), weeks: demoWeeks)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(SimpleEntry(date: Date(), weeks: demoWeeks))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            var entries: [SimpleEntry] = []

            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let weeks = await fetchData()
            let date = Calendar.current.date(byAdding: .hour, value: 0, to: Date())!
            entries.append(SimpleEntry(date: date, weeks: weeks))

//            let currentDate = Date()
//            for hourOffset in 0 ..< 5 {
//                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//                let entry = SimpleEntry(date: entryDate)
//                entries.append(entry)
//            }

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

struct SimpleEntry: TimelineEntry {
    var date: Date
    let weeks: [[String]]
}

struct WristGraphWidget_WatchEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        GeometryReader { geometry in
            let size = (geometry.size.height * 5 - 10) / 41

            Grid(horizontalSpacing: size / 5, verticalSpacing: size / 5) {
                ForEach(0..<entry.weeks.count, id: \.self) { i in
                    GridRow {
                        ForEach(0..<entry.weeks[i].count, id: \.self) { j in
                            GraphElement(contributionLevel: entry.weeks[i][j], size: size)
                                .widgetAccentable()
                        }
                    }
                }
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
        .configurationDisplayName("Github Contribution Graph")
    }
}

struct WristGraphWidget_Watch_Previews: PreviewProvider {
    static var previews: some View {
        WristGraphWidget_WatchEntryView(entry: SimpleEntry(date: Date(), weeks: [[String()]]))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
