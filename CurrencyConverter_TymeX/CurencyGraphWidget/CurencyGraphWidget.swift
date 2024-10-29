//
//  CurencyGraphWidget.swift
//  CurencyGraphWidget
//
//  Created by Huynh Nguyen Tuan Duy on 29/10/24.
//

import WidgetKit
import SwiftUI
import Charts
struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), widgetConverions: widgetConversions)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, widgetConverions: widgetConversions)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        //create a interval of 30 minutes for refreshing the timeline
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
        let entry = SimpleEntry(date: currentDate, configuration: configuration, widgetConverions: widgetConversions )
            entries.append(entry)
        return Timeline(entries: entries, policy: .after(nextUpdateDate))
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let widgetConverions: [WidgetConversion]
}

struct CurencyGraphWidgetEntryView : View {
    var entry: Provider.Entry
    @AppStorage("selectedConversion") private var selectedConversion: String = "1"
    var body: some View {
        VStack{
            Text(entry.date, style: .date)
                .font(.caption2)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Tỉ lệ chuyển đổi")
                .font(.custom("AvenirNext-Bold", size: 25))
                .foregroundStyle(.ccPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            ///Segmented controls with intents button ios 17.0
            HStack(spacing: 0){
                ForEach(entry.widgetConverions) { conversions in
                    Button(intent: TabButtonIntent(conversionID: conversions.id) ){
                        Text(conversions.conversionPair)
                            .font(.caption)
                            .lineLimit(1)
                            .foregroundStyle(conversions.id == selectedConversion ? .white : .primary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }.background{
                GeometryReader {
                    let size = $0.size
                    let width = size.width / CGFloat(entry.widgetConverions.count)
                    Capsule()
                        .fill(.ccSecondary)
                        .frame(width: width)
                        .offset(x: width * CGFloat(selectedIndex))
                }
            }
            .frame(height: 28)
            .background(.primary.opacity(0.15), in: .capsule)
            Chart(selectedConversionPair){ data in
                if entry.configuration.isLineChart{
                    LineMark(
                        x: .value("Tháng/Năm", data.monthYear),
                        y: .value("Tỉ lệ", data.conversionRate)
                    ).interpolationMethod(.catmullRom)
                    //low gradient part
                    AreaMark(
                        x: .value("Tháng/Năm", data.monthYear),
                        y: .value("Tỉ lệ", data.conversionRate)
                    ).interpolationMethod(.catmullRom)
                        .foregroundStyle(.linearGradient(colors:[
                            Color.ccPrimary,
                            Color.ccPrimary.opacity(0.4),
                            .clear
                        ], startPoint: .top, endPoint: .bottom))
                }else{
                    BarMark(
                        x: .value("Tháng/Năm", data.monthYear),
                        y: .value("Tỉ lệ", data.conversionRate)
                    ).interpolationMethod(.catmullRom)
                        .foregroundStyle(.ccTertiary)
                }
            }
        }
    }
    
    var selectedConversionPair: [ChartModelInputWidget] {
        return entry.widgetConverions.first(where: { $0.id == selectedConversion})?.data ?? []
    }
    var selectedIndex: Int {
        return entry.widgetConverions.firstIndex(where: { $0.id == selectedConversion}) ?? 0
    }

}

struct CurencyGraphWidget: Widget {
    let kind: String = "CurencyGraphWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            CurencyGraphWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        ///widget size medium big small do
        .supportedFamilies([
            .systemLarge,
            .systemExtraLarge
        ])
    }
}

#Preview(as: .systemLarge) {
    CurencyGraphWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .init(), widgetConverions: widgetConversions)
}
