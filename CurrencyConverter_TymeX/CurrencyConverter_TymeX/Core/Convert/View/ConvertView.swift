//
//  ConvertView.swift
//  CurrencyConverter_TymeX
//
//  Created by Huynh Nguyen Tuan Duy on 27/10/24.
//

import SwiftUI
import Charts

struct ConvertView: View {
    @StateObject private var viewmodel: ConvertViewModel
    init(){
        _viewmodel = StateObject(wrappedValue: ConvertViewModel(exchangeRatesService: ExchangeRatesService(httpClient: HTTPClient())))
    }
    var body: some View {
        NavigationStack {
            ScrollView {
                switch viewmodel.loadingState {
                case .loading:
                    ExchangeWindowPlaceHolder()
                        .padding(.vertical)
                case .finished:
                    ConvertWindowView()
                        .padding(.vertical)
//                    if let chartModelInput = viewmodel.chartModelInput {
                    VStack{
                        Text("\(ChartModelInput.sample1.first!.baseCurrency) to \(ChartModelInput.sample1.first!.targetCurrency) Chart")
                            .modifier(BoldTextModifier(textSize: 25))
                            .foregroundStyle(.ccTertiary)
                        Chart(ChartModelInput.sample1){ chartModel in
                            LineMark(
                                x: .value("Tháng/Năm", chartModel.monthYear ),
                                y: .value("Tỉ lệ chuyển đổi", chartModel.conversionRate )
                            ).interpolationMethod(.catmullRom)
                            AreaMark(
                                x: .value("Tháng/Năm", chartModel.monthYear ),
                                y: .value("Tỉ lệ chuyển đổi", chartModel.conversionRate)
                            ).interpolationMethod(.catmullRom)
                                .foregroundStyle(.linearGradient(colors:[
                                    Color.blue,
                                    Color.blue.opacity(0.5),
                                    .clear
                                ], startPoint: .top, endPoint: .bottom))
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    VStack{
                        Text("\(ChartModelInput.sample2.first!.baseCurrency) to \(ChartModelInput.sample2.first!.targetCurrency) Chart")
                            .modifier(BoldTextModifier(textSize: 25))
                            .foregroundStyle(.ccTertiary)
                        Chart(ChartModelInput.sample2){ chartModel in
                            LineMark(
                                x: .value("Tháng/Năm", chartModel.monthYear ),
                                y: .value("Tỉ lệ chuyển đổi", chartModel.conversionRate )
                            ).interpolationMethod(.catmullRom)
                            AreaMark(
                                x: .value("Tháng/Năm", chartModel.monthYear ),
                                y: .value("Tỉ lệ chuyển đổi", chartModel.conversionRate)
                            ).interpolationMethod(.catmullRom)
                                .foregroundStyle(.linearGradient(colors:[
                                    Color.blue,
                                    Color.blue.opacity(0.5),
                                    .clear
                                ], startPoint: .top, endPoint: .bottom))
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    VStack{
                        Text("\(ChartModelInput.sample3.first!.baseCurrency) to \(ChartModelInput.sample3.first!.targetCurrency) Chart")
                            .modifier(BoldTextModifier(textSize: 25))
                            .foregroundStyle(.ccTertiary)
                        Chart(ChartModelInput.sample3){ chartModel in
                            LineMark(
                                x: .value("Tháng/Năm", chartModel.monthYear ),
                                y: .value("Tỉ lệ chuyển đổi", chartModel.conversionRate )
                            ).interpolationMethod(.catmullRom)
                            AreaMark(
                                x: .value("Tháng/Năm", chartModel.monthYear ),
                                y: .value("Tỉ lệ chuyển đổi", chartModel.conversionRate)
                            ).interpolationMethod(.catmullRom)
                                .foregroundStyle(.linearGradient(colors:[
                                    Color.blue,
                                    Color.blue.opacity(0.5),
                                    .clear
                                ], startPoint: .top, endPoint: .bottom))
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
//                    }
                case .idle:
                    EmptyView()
                }
            }.alert(item: $viewmodel.error) { error in
                switch error {
                case .badRequest:
                    return Alert(title: Text("Bad Request"), message: Text("Unable to perform the request."), dismissButton: .default(Text("OK")))
                case .decodingError(let decodingError):
                    return Alert(title: Text("Decoding Error"), message: Text(decodingError.localizedDescription), dismissButton: .default(Text("OK")))
                case .invalidResponse:
                    return Alert(title: Text("Invalid Response"), message: Text("The server response was invalid."), dismissButton: .default(Text("OK")))
                case .errorResponse(let errorResponse):
                    return Alert(title: Text("Lỗi"), message: Text(errorResponse.result ?? "Đã xảy ra lỗi"), dismissButton: .default(Text("OK")))
                }
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .navigationTitle("Chuyển đổi tiền tệ")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "wifi")
                        .foregroundStyle(.green)
                }
            }
        }
    }

    @ViewBuilder
    func ConvertWindowView() -> some View {
        VStack(alignment: .leading) {
            Picker("Loại tiền tệ", selection: $viewmodel.selectedBaseCurrency){
                ForEach(viewmodel.supportedCodes, id: \.self) { code in
                    Text("\(code.name) - \(code.code)")
                        .tag(code)
                }
            }
            .foregroundStyle(.ccPrimary)
            .pickerStyle(.navigationLink)
            .modifier(RegularTextModifier(textSize: 16))
            Text("1 \(viewmodel.selectedBaseCurrency?.code ?? "") = \(viewmodel.conversionRate ?? 1.0, specifier: "%.6f") \(viewmodel.selectedTargetCurrency?.code ?? "")")
                .modifier(RegularTextModifier(textSize: 15))
                .foregroundStyle(.gray)
            TextField("Enter amount", text: $viewmodel.baseCurrencyAmount)
                .modifier(DemiBoldTextModifier(textSize: 25))
                .keyboardType(.decimalPad)
            Divider()
            Picker("Loại tiền tệ", selection: $viewmodel.selectedTargetCurrency){
                ForEach(viewmodel.supportedCodes, id: \.self) { code in
                    Text("\(code.name) - \(code.code)")
                        .tag(code)
                }
            }
            .foregroundStyle(.ccPrimary)
            .pickerStyle(.navigationLink)
            .modifier(RegularTextModifier(textSize: 16))
            Text("1 \(viewmodel.selectedTargetCurrency?.code ?? "") = \((1 / (viewmodel.conversionRate ?? 1.0)), specifier: "%.6f") \(viewmodel.selectedBaseCurrency?.code ?? "")")
                .modifier(RegularTextModifier(textSize: 15))
                .foregroundStyle(.gray)
            TextField("Enter amount", text: $viewmodel.targetCurrencyAmount)
                .modifier(DemiBoldTextModifier(textSize: 25))
                .keyboardType(.decimalPad)
            VStack(alignment: .leading){
                Text("Lần cập nhật gần đây nhất: \(viewmodel.exchangeRates?.timeLastUpdateUnix.toFormattedDate() ?? "N/A")")
                Text("Lần cập nhật tiếp theo: \(viewmodel.exchangeRates?.timeNextUpdateUnix.toFormattedDate() ?? "N/A")")
            }
            .modifier(RegularTextModifier(textSize: 15))
            .foregroundStyle(.ccSecondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.background)
                .shadow(
                    color: Color.ccPrimary.opacity(0.7),
                    radius: 8,
                    x: 0,
                    y: 0
                )
        )
        .padding(.horizontal)
        //TODO: Adding props here
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ConvertView()
}
