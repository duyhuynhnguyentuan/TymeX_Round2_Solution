//
//  ExchangeRatesViewModel.swift
//  CurrencyConverter_TymeX
//
//  Created by Huynh Nguyen Tuan Duy on 29/10/24.
//

import Foundation
import Combine

class ExchangeRatesViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let selectedBaseCurrencySubject: PassthroughSubject<CurrencyCode, Never> = .init()
    @Published var selectedBaseCurrency: CurrencyCode?{
        didSet{
            selectedBaseCurrencySubject.send(selectedBaseCurrency!)
        }
    }
    @Published private(set) var exchangeRates: ExchangeRateResponse?
    @Published private(set) var supportedCodes = [CurrencyCode]()
    /// Loading states
    @Published private(set) var loadingState: LoadingState = .idle
    
    /// Handle errors
    @Published var error: NetworkError?
    @Published var generalError: Error?
    let exchangeRatesService: ExchangeRatesService
    
    init(exchangeRatesService: ExchangeRatesService) {
        self.exchangeRatesService = exchangeRatesService
        loadData()
        observe()
    }
    
    @MainActor
    func loadExchangeRates(from baseCurrency: String) async throws {
        defer { loadingState = .finished }
        
        do {
            loadingState = .loading
            let result = try await exchangeRatesService.loadExchangeRates(from: baseCurrency)
            self.exchangeRates = result
        } catch let error as NetworkError {
            self.error = error
            throw error
        } catch {
            self.generalError = error
            throw error
        }
    }
    
    @MainActor
    func loadSupportedCodes() async throws {
        defer { loadingState = .finished }
        
        do {
            loadingState = .loading
            let result = try await exchangeRatesService.loadCodes()
            self.supportedCodes = result.supportedCodes
        } catch let error as NetworkError {
            self.error = error
            throw error
        } catch {
            self.generalError = error
            throw error
        }
    }
    func loadData() {
        Task(priority: .medium) {
            try await loadSupportedCodes()
        }
    }
    //observe input
    private func observe() {
        selectedBaseCurrencySubject
            .sink { [weak self] selectedBaseCurrency in
                guard let self = self else { return }
                Task{
                    try await self.loadExchangeRates(from: selectedBaseCurrency.code)
                }
            }.store(in: &cancellables)
    }
}
