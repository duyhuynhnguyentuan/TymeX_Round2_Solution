//
//  AppIntent.swift
//  CurencyGraphWidget
//
//  Created by Huynh Nguyen Tuan Duy on 29/10/24.
//

import WidgetKit
import AppIntents

///add button intent for interaction
struct TabButtonIntent: AppIntent {
    static var title: LocalizedStringResource = "Tab Button Intent"
    @Parameter(title: "Conversion ID", default: "")
    var conversionID: String
    init(){
        
    }
    init(conversionID: String){
        self.conversionID = conversionID
    }
    func perform() async throws -> some IntentResult {
        UserDefaults.standard.set(conversionID, forKey: "selectedConversion")
        return .result()
    }
}
///custom parameter in widget
struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "This is an example widget." }

    // An example configurable parameter.
    @Parameter(title: "line chart", default: false)
    var isLineChart: Bool
    @Parameter(title: "Base currency", default: "USD")
    var baseCur: String
}
