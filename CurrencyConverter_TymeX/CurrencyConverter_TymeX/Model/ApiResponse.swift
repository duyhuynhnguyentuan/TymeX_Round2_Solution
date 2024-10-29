//
//  ApiResponse.swift
//  CurrencyConverter_TymeX
//
//  Created by Huynh Nguyen Tuan Duy on 27/10/24.
//

import Foundation

//MARK: - API Response for Supported Code
struct SupportedCodeResponse: Codable {
    let result: String
    let documentation: String
    let termsOfUse: String
    let supportedCodes: [CurrencyCode]
    enum CodingKeys: String, CodingKey {
        case result
        case documentation
        case termsOfUse = "terms_of_use"
        case supportedCodes = "supported_codes"
    }
}

struct CurrencyCode: Codable, Hashable {
    let code: String
    let name: String
    
    // Since supported_codes is an array of arrays, we need a custom initializer
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        code = try container.decode(String.self)
        name = try container.decode(String.self)
    }
}

//MARK: - API Response for Historical Data
struct HistoricalResponse: Codable {
    let result: String
    let documentation: String
    let termsOfUse: String
    let year: Int
    let month: Int
    let day: Int
    let baseCode: String
    let conversionRates: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case result
        case documentation
        case termsOfUse = "terms_of_use"
        case year
        case month
        case day
        case baseCode = "base_code"
        case conversionRates = "conversion_rates"
    }
}

//MARK: - API Response for Exchange rates pair conversion
struct PairConversionResponse: Codable {
    let result: String
    let documentation: String
    let termsOfUse: String
    let timeLastUpdateUnix: Int
    let timeLastUpdateUTC: String
    let timeNextUpdateUnix: Int
    let timeNextUpdateUTC: String
    let baseCode: String
    let targetCode: String
    let conversionRate: Double
    
    enum CodingKeys: String, CodingKey {
        case result
        case documentation
        case termsOfUse = "terms_of_use"
        case timeLastUpdateUnix = "time_last_update_unix"
        case timeLastUpdateUTC = "time_last_update_utc"
        case timeNextUpdateUnix = "time_next_update_unix"
        case timeNextUpdateUTC = "time_next_update_utc"
        case baseCode = "base_code"
        case targetCode = "target_code"
        case conversionRate = "conversion_rate"
    }
}

//MARK: - API Response for exchange rates from base currency
struct ExchangeRateResponse: Codable {
    let result: String
    let documentation: String
    let termsOfUse: String
    let timeLastUpdateUnix: Int
    let timeLastUpdateUtc: String
    let timeNextUpdateUnix: Int
    let timeNextUpdateUtc: String
    let baseCode: String
    let conversionRates: [String: Double]
    
    private enum CodingKeys: String, CodingKey {
        case result
        case documentation
        case termsOfUse = "terms_of_use"
        case timeLastUpdateUnix = "time_last_update_unix"
        case timeLastUpdateUtc = "time_last_update_utc"
        case timeNextUpdateUnix = "time_next_update_unix"
        case timeNextUpdateUtc = "time_next_update_utc"
        case baseCode = "base_code"
        case conversionRates = "conversion_rates"
    }
}

//MARK: - Model for chart
struct ChartModelInput: Codable, Identifiable, Equatable {
    var id: UUID = .init()
    let baseCurrency: String
    let targetCurrency: String
    let conversionRate: Double
    let monthYear: String
}
extension ChartModelInput {
    static var sample1 = [
        ChartModelInput(baseCurrency: "USD",
                        targetCurrency: "VND",
                        conversionRate: 25000,
                        monthYear: "04/2024"),
        ChartModelInput(baseCurrency: "USD",
                        targetCurrency: "VND",
                        conversionRate: 25471,
                        monthYear: "05/2024"),
        ChartModelInput(baseCurrency: "USD",
                        targetCurrency: "VND",
                        conversionRate: 24900,
                        monthYear: "06/2024"),
        ChartModelInput(baseCurrency: "USD",
                        targetCurrency: "VND",
                        conversionRate: 24800,
                        monthYear: "07/2024"),
        ChartModelInput(baseCurrency: "USD",
                        targetCurrency: "VND",
                        conversionRate: 24750,
                        monthYear: "08/2024"),
        ChartModelInput(baseCurrency: "USD",
                        targetCurrency: "VND",
                        conversionRate: 24603,
                        monthYear: "09/2024")
    ]
    
    static var sample2 = [
        ChartModelInput(baseCurrency: "USD",
                        targetCurrency: "GBP",
                        conversionRate: 0.78,
                        monthYear: "05/2024"),
        ChartModelInput(baseCurrency: "USD",
                        targetCurrency: "GBP",
                        conversionRate: 0.76,
                        monthYear: "06/2024"),
        ChartModelInput(baseCurrency: "USD",
                        targetCurrency: "GBP",
                        conversionRate: 0.75,
                        monthYear: "07/2024"),
        ChartModelInput(baseCurrency: "USD",
                        targetCurrency: "GBP",
                        conversionRate: 0.74,
                        monthYear: "08/2024"),
        ChartModelInput(baseCurrency: "USD",
                        targetCurrency: "GBP",
                        conversionRate: 0.73,
                        monthYear: "09/2024")
    ]
    
    static var sample3 = [
        ChartModelInput(baseCurrency: "USD",
                        targetCurrency: "EUR",
                        conversionRate: 0.86,
                        monthYear: "06/2024"),
        ChartModelInput(baseCurrency: "USD",
                        targetCurrency: "EUR",
                        conversionRate: 0.85,
                        monthYear: "07/2024"),
        ChartModelInput(baseCurrency: "USD",
                        targetCurrency: "EUR",
                        conversionRate: 0.84,
                        monthYear: "08/2024"),
        ChartModelInput(baseCurrency: "USD",
                        targetCurrency: "EUR",
                        conversionRate: 0.83,
                        monthYear: "09/2024")
    ]
}


