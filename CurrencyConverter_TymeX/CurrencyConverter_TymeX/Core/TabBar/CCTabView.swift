//
//  CCTabView.swift
//  CurrencyConverter_TymeX
//
//  Created by Huynh Nguyen Tuan Duy on 27/10/24.
//

import SwiftUI

struct CCTabView: View {
    @State private var selectedTab = 0
    var body: some View {
        TabView{
            Tab("Convert", systemImage: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90") {
                ConvertView()
            }
            Tab("Rates", systemImage: "dongsign.bank.building"){
                ExchangeRatesView()
            }
            Tab("Widget", systemImage: "widget.small.badge.plus"){
                WidgetView()
            }
            }
        .tabViewStyle(.sidebarAdaptable)
        .tint(Color.ccPrimary)
    }
}

#Preview {
    CCTabView()
}
