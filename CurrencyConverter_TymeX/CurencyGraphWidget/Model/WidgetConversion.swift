//
//  widgetConversion.swift
//  CurrencyConverter_TymeX
//
//  Created by Huynh Nguyen Tuan Duy on 29/10/24.
//

import Foundation

struct WidgetConversion: Identifiable {
    var id: String
    var conversionPair: String
    var data: [ChartModelInputWidget]
}
//const for using in the widget
let widgetConversions: [WidgetConversion] = [
    .init(id: "1", conversionPair: "USD-VND", data: ChartModelInputWidget.sample1),
    .init(id: "2", conversionPair: "USD-GBP", data: ChartModelInputWidget.sample2),
    .init(id: "3", conversionPair: "USD-EUR", data: ChartModelInputWidget.sample3),
]

struct ChartModelInputWidget: Codable, Identifiable, Equatable {
    var id: UUID = .init()
    let baseCurrency: String
    let targetCurrency: String
    let conversionRate: Double
    let monthYear: String
}
extension ChartModelInputWidget {
    static var sample1 = [
        ChartModelInputWidget(baseCurrency: "USD",
                        targetCurrency: "VND",
                        conversionRate: 25000,
                        monthYear: "04/2024"),
        ChartModelInputWidget(baseCurrency: "USD",
                        targetCurrency: "VND",
                        conversionRate: 25471,
                        monthYear: "05/2024"),
        ChartModelInputWidget(baseCurrency: "USD",
                        targetCurrency: "VND",
                        conversionRate: 24900,
                        monthYear: "06/2024"),
        ChartModelInputWidget(baseCurrency: "USD",
                        targetCurrency: "VND",
                        conversionRate: 24800,
                        monthYear: "07/2024"),
        ChartModelInputWidget(baseCurrency: "USD",
                        targetCurrency: "VND",
                        conversionRate: 24750,
                        monthYear: "08/2024"),
        ChartModelInputWidget(baseCurrency: "USD",
                        targetCurrency: "VND",
                        conversionRate: 24603,
                        monthYear: "09/2024")
    ]
    
    static var sample2 = [
        ChartModelInputWidget(baseCurrency: "USD",
                        targetCurrency: "GBP",
                        conversionRate: 0.78,
                        monthYear: "05/2024"),
        ChartModelInputWidget(baseCurrency: "USD",
                        targetCurrency: "GBP",
                        conversionRate: 0.76,
                        monthYear: "06/2024"),
        ChartModelInputWidget(baseCurrency: "USD",
                        targetCurrency: "GBP",
                        conversionRate: 0.75,
                        monthYear: "07/2024"),
        ChartModelInputWidget(baseCurrency: "USD",
                        targetCurrency: "GBP",
                        conversionRate: 0.74,
                        monthYear: "08/2024"),
        ChartModelInputWidget(baseCurrency: "USD",
                        targetCurrency: "GBP",
                        conversionRate: 0.73,
                        monthYear: "09/2024")
    ]
    
    static var sample3 = [
        ChartModelInputWidget(baseCurrency: "USD",
                        targetCurrency: "EUR",
                        conversionRate: 0.86,
                        monthYear: "06/2024"),
        ChartModelInputWidget(baseCurrency: "USD",
                        targetCurrency: "EUR",
                        conversionRate: 0.85,
                        monthYear: "07/2024"),
        ChartModelInputWidget(baseCurrency: "USD",
                        targetCurrency: "EUR",
                        conversionRate: 0.84,
                        monthYear: "08/2024"),
        ChartModelInputWidget(baseCurrency: "USD",
                        targetCurrency: "EUR",
                        conversionRate: 0.83,
                        monthYear: "09/2024")
    ]
}
