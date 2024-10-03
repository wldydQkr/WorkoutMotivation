//
//  MotivationWidget.swift
//  MotivationWidget
//
//  Created by 박지용 on 6/12/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), quote: "Stay hungry, stay foolish.", author: "Steve Jobs")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), quote: "Stay hungry, stay foolish.", author: "Steve Jobs")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, quote: "Stay hungry, stay foolish.", author: "Steve Jobs")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let quote: String
    let author: String
}

struct MotivationWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("\"\(entry.quote)\"")
                .font(.headline)
                .padding(.bottom, 10)
            Text("- \(entry.author)")
                .font(.subheadline)

        }
        .padding()
    }
}

struct MotivationWidget: Widget {
    let kind: String = "MotivationWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MotivationWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Motivation Widget")
        .description("Displays a motivational quote.")
    }
}

struct MotivationWidget_Previews: PreviewProvider {
    static var previews: some View {
        MotivationWidgetEntryView(entry: SimpleEntry(date: Date(), quote: "Stay hungry, stay foolish.", author: "Steve Jobs"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
