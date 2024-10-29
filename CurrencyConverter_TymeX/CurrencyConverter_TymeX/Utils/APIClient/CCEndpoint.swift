//
//  CCEndpoint.swift
//  CurrencyConverter_TymeX
//
//  Created by Huynh Nguyen Tuan Duy on 27/10/24.
//

import Foundation

@frozen enum CCEndpoint: String, CaseIterable, Hashable {
    ///endpoint to get the lastest exchange rates from base currency
    case latest
    ///endpoint for Exchange rate pair conversion with amount
    case pair
    /// enpoint for historical data (year/month/day...)
    case history
    /// endpoint for supported code currencies
    case codes
}
