//
//  MyWidget.swift
//  MyWidget
//
//  Created by 林湘羚 on 2021/1/13.
//

import WidgetKit
import SwiftUI
//import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), equations: "jackson")
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), equations: "jackson")
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 60 {
            let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, equations: MyDataProvider.getequations())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let equations: String
}

struct MyWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack{
            Color(red: 240/255, green: 128/255, blue: 128/255).edgesIgnoringSafeArea(.all)
            Text(entry.equations)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .font(.largeTitle)
        }
    }
}

@main
struct MyWidget: Widget {
    let kind: String = "MyWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("易烊千璽")
        .description("千璽老婆專用")
    }
}

struct MyWidget_Previews: PreviewProvider {
    static var previews: some View {
        MyWidgetEntryView(entry: SimpleEntry(date: Date(), equations: "jackson"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

class MyDataProvider{
    static func getequations() -> String{
        let strings = ["易烊千璽\n我的愛", "沒人娶\n就找千璽", "千璽老婆\n在這裡", "千璽快來\n養我"]
        return strings.randomElement()!
    }
}
