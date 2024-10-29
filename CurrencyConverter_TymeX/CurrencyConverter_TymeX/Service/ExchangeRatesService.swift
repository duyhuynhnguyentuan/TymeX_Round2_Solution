//
//  ExchangeRatesService.swift
//  CurrencyConverter_TymeX
//
//  Created by Huynh Nguyen Tuan Duy on 27/10/24.
//

import Foundation

///all the exchanges rates api calles are handled in this one file

protocol ExchangeRatesServiceProtocol {
    /// Load all the supported codes provided by API
    /// - Returns: Json supported response
    func loadCodes() async throws -> SupportedCodeResponse
    /// load exchange ratess from base currency
    /// - Parameter baseCurrency: bsae currency like USD...
    /// - Returns: return a response
    func loadExchangeRates(from baseCurrency: String) async throws -> ExchangeRateResponse
    /// load historical Data from base currency in day, month, year
    /// - Parameters:
    ///   - baseCurrency: baseCurrency(VND, USD,..)
    ///   - year: the year (2024)
    ///   - month: month
    ///   - day: day
    /// - Returns: returns a resopnse
    func loadHistoricalData(from baseCurrency: String, in year: Int, in month: Int, on day: Int) async throws -> HistoricalResponse
}

class ExchangeRatesService: ExchangeRatesServiceProtocol{
    let httpClient: HTTPClient
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    @MainActor
    func loadCodes() async throws -> SupportedCodeResponse {
        let loadCodesRequest = CCRequest(endpoint: .codes)
        let loadCodesResource = Resource(url: loadCodesRequest.url!, modelType: SupportedCodeResponse.self)
        let loadCodesResponse = try await httpClient.load(loadCodesResource)
        return loadCodesResponse
    }
    
    @MainActor
    func loadExchangeRates(from baseCurrency: String) async throws -> ExchangeRateResponse {
        let loadExchangeRatesRequest = CCRequest(endpoint: .latest, pathComponents: [baseCurrency])
        let loadExchangeRatesResource = Resource(url: loadExchangeRatesRequest.url!, modelType: ExchangeRateResponse.self)
        let loadExchangeRatesResponse = try await httpClient.load(loadExchangeRatesResource)
        return loadExchangeRatesResponse
    }
    
    @MainActor
    func loadHistoricalData(from baseCurrency: String, in year: Int, in month: Int, on day: Int) async throws -> HistoricalResponse {
        let loadHistoricalDataRequest = CCRequest(endpoint: .history, pathComponents: [baseCurrency, String(year), String(month), String(day)])
        let loadHistoricalDataResource = Resource(url: loadHistoricalDataRequest.url!, modelType: HistoricalResponse.self)
        let loadHistoricalDataResponse = try await httpClient.load(loadHistoricalDataResource)
        return loadHistoricalDataResponse
    }

}
