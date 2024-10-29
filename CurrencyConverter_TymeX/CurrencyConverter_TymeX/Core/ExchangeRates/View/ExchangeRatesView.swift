//
//  ExchangeRatesView.swift
//  CurrencyConverter_TymeX
//
//  Created by Huynh Nguyen Tuan Duy on 27/10/24.
//

import SwiftUI

struct ExchangeRatesView: View {
    @StateObject var viewModel: ExchangeRatesViewModel
    init(){
        _viewModel = StateObject(wrappedValue: ExchangeRatesViewModel(exchangeRatesService: ExchangeRatesService(httpClient: HTTPClient())))
    }
    var body: some View {
        NavigationStack{
            switch viewModel.loadingState {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView()
            case .finished:
                ScrollView{
                    VStack(alignment:.leading, spacing: 10){
                        Picker("Loại tiền tệ", selection: $viewModel.selectedBaseCurrency){
                            ForEach(viewModel.supportedCodes, id: \.self) { code in
                                Text("\(code.name) - \(code.code)")
                                    .tag(code)
                            }
                        }
                        .padding()
                        .background(
                            Capsule()
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .foregroundStyle(.ccPrimary)
                        .pickerStyle(.navigationLink)
                        .padding(.horizontal)
                        VStack{
                            Text("Lần update gần nhất: \(viewModel.exchangeRates?.timeLastUpdateUtc ?? "N/A") ")
                            Text("Lần update tiếp theo: \(viewModel.exchangeRates?.timeNextUpdateUtc ?? "N/A")")
                        }
                        .padding(.horizontal)
                        .foregroundStyle(.secondary)
                        //MARK: -cells detail
                        if let exchangeRates = viewModel.exchangeRates?.conversionRates {
                            VStack(spacing: 10){
                            ForEach(exchangeRates.sorted(by: { $0.key < $1.key }), id: \.key) { currencyCode, rate in
                                VStack(alignment: .leading){
                                    Text(currencyCode)
                                        .modifier(DemiBoldTextModifier(textSize: 19))
                                        .foregroundStyle(.gray)
                                    Text("\(rate, specifier: "%.4f")")
                                        .modifier(BoldTextModifier(textSize: 25))
                                    
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.horizontal)
                                .background(
                                    Capsule()
                                        .stroke(Color.ccPrimary, lineWidth: 3)
                                        .padding(.horizontal)
                                )
                            }
                        }
                        }
                    }
                    
                }
                .navigationTitle("Tỉ lệ chuyển đổi")
                .transition(.blurReplace)
            }
        }
        .animation(.smooth(duration: 0.5), value: viewModel.loadingState)
    }
}

#Preview {
    ExchangeRatesView()
}
