//
//  ConvertViewModel.swift
//  CurrencyConverter_TymeX
//
//  Created by Huynh Nguyen Tuan Duy on 27/10/24.
//

import Foundation
import SwiftUI
import Combine

class ConvertViewModel: ObservableObject {
    /// Combine
    private var cancellables: Set<AnyCancellable> = []
    private let selectedBaseCurrencySubject: PassthroughSubject<CurrencyCode, Never> = .init()
    private let selectedTargetCurrencySubject: PassthroughSubject<CurrencyCode, Never> = .init()
    
    /// Textfields observe
    private let baseCurrencyAmountSubject: CurrentValueSubject<Double, Never> = .init(1.0)
    // Erase to put in the parameter of input struct
    var baseCurrencyAmountValuePublisher: AnyPublisher<Double, Never> {
        return baseCurrencyAmountSubject.eraseToAnyPublisher()
    }
    private let targetCurrencyAmountSubject: CurrentValueSubject<Double, Never> = .init(1.0)
    var targetCurrencyAmountValuePublisher: AnyPublisher<Double, Never> {
        return targetCurrencyAmountSubject.eraseToAnyPublisher()
    }
    private let conversionRateSubject: CurrentValueSubject<Double?, Never> = .init(nil)
    var conversionRateValuePublisher: AnyPublisher<Double?, Never> {
        return conversionRateSubject.eraseToAnyPublisher()
    }
    /// Other declarations
    @Published var conversionRate: Double? {
        didSet {
            conversionRateSubject.send(conversionRate)
        }
    }
    @Published var selectedBaseCurrency: CurrencyCode? {
        didSet {
            selectedBaseCurrencySubject.send(selectedBaseCurrency!)
        }
    }
    @Published var selectedTargetCurrency: CurrencyCode? {
        didSet {
            selectedTargetCurrencySubject.send(selectedTargetCurrency!)
        }
    }
    @Published private(set) var supportedCodes = [CurrencyCode]()
    @Published private(set) var exchangeRates: ExchangeRateResponse?
//    @Published private(set) var chartModelInput: [ChartModelInput]?
    /// TextFields texts
    @Published var baseCurrencyAmount: String = "0" {
        didSet {
            baseCurrencyAmountSubject.send(baseCurrencyAmount.doubleValue ?? 1.0)
        }
    }
    @Published var targetCurrencyAmount: String = "0" {
        didSet {
            targetCurrencyAmountSubject.send(targetCurrencyAmount.doubleValue ?? 1.0)
        }
    }
    
    /// Loading states
    @Published private(set) var loadingState: LoadingState = .idle
    
    /// Handle errors
    @Published var error: NetworkError?
    @Published var generalError: Error?
    
    let exchangeRatesService: ExchangeRatesService
    
    init(exchangeRatesService: ExchangeRatesService) {
        self.exchangeRatesService = exchangeRatesService
        loadData()
    }
    
    // MARK: - Functions
    /// Observe changes to perform actions
    @MainActor
    ///update conversionrate and amount when there's new input
    private func updateConversionRateAndAmounts() {
        Task {
            //optinoal chaining
            if let baseCurrencyCode = selectedBaseCurrency?.code,
               let targetCurrencyCode = selectedTargetCurrency?.code {
                try await loadExchangeRates(from: baseCurrencyCode)
                self.conversionRate = self.exchangeRates?.conversionRates[targetCurrencyCode]
                if let conversionRate = self.conversionRate {
                    let baseAmount = baseCurrencyAmountSubject.value
                    let targetAmount = baseAmount * conversionRate
                    baseCurrencyAmount = String(format: "%.6f", baseAmount)
                    targetCurrencyAmount = String(format: "%.6f", targetAmount)
                } else {
                    resetAmounts()
                }
                //API bat upgrade nen khong xai duoc 
                //both currency are selected, called apis to make graph
                //from january to october of 2024
//                let januaryData = try await loadHistoricalDate(from: baseCurrencyCode, in: 2024, in: 1, on: 15)
//                let februaryData = try await loadHistoricalDate(from: baseCurrencyCode, in: 2024, in: 2, on: 15)
//                let marchData = try await loadHistoricalDate(from: baseCurrencyCode, in: 2024, in: 3, on: 15)
//                let aprilData = try await loadHistoricalDate(from: baseCurrencyCode, in: 2024, in: 4, on: 15)
//                let mayData = try await loadHistoricalDate(from: baseCurrencyCode, in: 2024, in: 5, on: 15)
                
//                let juneData = try await loadHistoricalDate(from: baseCurrencyCode, in: 2024, in: 6, on: 15)
//                let julyData = try await loadHistoricalDate(from: baseCurrencyCode, in: 2024, in: 7, on: 15)
//                let augustData = try await loadHistoricalDate(from: baseCurrencyCode, in: 2024, in: 8, on: 15)
//                self.chartModelInput = [
//                    ChartModelInput(baseCurrency: baseCurrencyCode, targetCurrency: targetCurrencyCode, conversionRate: mayData.conversionRates[targetCurrencyCode] ?? 0.0, monthYear: "\(mayData.month)/\(mayData.year)"),
//                    ChartModelInput(baseCurrency: baseCurrencyCode, targetCurrency: targetCurrencyCode, conversionRate: juneData.conversionRates[targetCurrencyCode] ?? 0.0, monthYear: "\(juneData.month)/\(juneData.year)"),
//                    ChartModelInput(baseCurrency: baseCurrencyCode, targetCurrency: targetCurrencyCode, conversionRate: julyData.conversionRates[targetCurrencyCode] ?? 0.0, monthYear:  "\(julyData.month)/\(julyData.year)"),
//                    ChartModelInput(baseCurrency: baseCurrencyCode, targetCurrency: targetCurrencyCode, conversionRate: augustData.conversionRates[targetCurrencyCode] ?? 0.0, monthYear: "\(augustData.month)/\(augustData.year)")
//                ]
            }
        }
    }
    
    private func resetAmounts() {
        baseCurrencyAmount = "1"
        targetCurrencyAmount = "0"
    }
    
    /// Observe selected currencies
    @MainActor
    private func observe() {
        selectedBaseCurrencySubject
            .sink { [weak self] _ in
                self?.updateConversionRateAndAmounts()
            }
            .store(in: &cancellables)
        
        selectedTargetCurrencySubject
            .sink { [weak self] _ in
                self?.updateConversionRateAndAmounts()
            }
            .store(in: &cancellables)
    }
    
    /// Bind changes to update views
    @MainActor
    private func bind() {
        let input = ConvertViewModelInput(
            conversionRatePublisher: conversionRateValuePublisher,
            targetCurrencyAmountPublisher: targetCurrencyAmountValuePublisher,
            selectedBaseCurrencyAmountPublisher: baseCurrencyAmountValuePublisher
        )
        let output = transform(input: input)
        
        output.updateViewPublisher
            .sink { [unowned self] result in
                self.baseCurrencyAmount = String(format: "%.6f", result.baseCurrencyAmount)
                self.targetCurrencyAmount = String(format: "%.6f", result.targetCurrencyAmount)
            }
            .store(in: &cancellables)
    }
    
    /// HTTP functions
    @MainActor
    func loadExchangeRates(from baseCurrency: String) async throws {
        defer { loadingState = .finished }
        
        do {
            loadingState = .loading
            let result = try await exchangeRatesService.loadExchangeRates(from: baseCurrency)
            self.exchangeRates = result
            self.conversionRate = self.exchangeRates?.conversionRates[selectedTargetCurrency?.code ?? ""]
        }
    }
    
    @MainActor
    func loadHistoricalDate(from baseCurrency: String, in year: Int, in month: Int, on day: Int) async throws -> HistoricalResponse {
        defer{
            loadingState = .finished
        }
        do {
            loadingState = .loading
            let result = try await exchangeRatesService.loadHistoricalData(from: baseCurrency, in: year, in: month, on: day)
            return result
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
            await bind()
            await observe()
        }
    }
    
    /// Observe inputs
    func transform(input: ConvertViewModelInput) -> ConvertViewModelOutput {
        let updateViewPublisher = Publishers.CombineLatest3(
            input.conversionRatePublisher,
            input.targetCurrencyAmountPublisher,
            input.selectedBaseCurrencyAmountPublisher
        )
        .flatMap { [unowned self] (conversionRate, targetCurrencyAmount, selectedBaseCurrencyAmount) in
            guard let rate = conversionRate else {
                return Just(Result(baseCurrencyAmount: selectedBaseCurrencyAmount, targetCurrencyAmount: targetCurrencyAmount)).eraseToAnyPublisher()
            }
            let baseCurrencyAmount = targetCurrencyAmount / rate
            let targetCurrencyAmountCalculated = selectedBaseCurrencyAmount * rate
            let result = Result(baseCurrencyAmount: baseCurrencyAmount, targetCurrencyAmount: targetCurrencyAmountCalculated)
            return Just(result).eraseToAnyPublisher()
        }.eraseToAnyPublisher()
        
        return ConvertViewModelOutput(updateViewPublisher: updateViewPublisher)
    }
}

// MARK: - Input and Output for observing and publishing changes
struct ConvertViewModelInput {
    let conversionRatePublisher: AnyPublisher<Double?, Never>
    let targetCurrencyAmountPublisher: AnyPublisher<Double, Never>
    let selectedBaseCurrencyAmountPublisher: AnyPublisher<Double, Never>
}

struct ConvertViewModelOutput {
    let updateViewPublisher: AnyPublisher<Result, Never>
}

struct Result {
    let baseCurrencyAmount: Double
    let targetCurrencyAmount: Double
}
