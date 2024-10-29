//
//  ExchangeWindowPlaceHolder.swift
//  CurrencyConverter_TymeX
//
//  Created by Huynh Nguyen Tuan Duy on 28/10/24.
//

import SwiftUI

struct ExchangeWindowPlaceHolder: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("Loai tien te")
                Spacer()
                Text("VND - Vietnamese Dong")
            }
            .foregroundStyle(.ccPrimary)
            .pickerStyle(.navigationLink)
            .modifier(RegularTextModifier(textSize: 16))
            Text("1 USD = 25.000 VND")
                .modifier(RegularTextModifier(textSize: 15))
                .foregroundStyle(.gray)
            TextField("Enter amount", text: .constant("1"))
                .modifier(DemiBoldTextModifier(textSize: 25))
            Divider()
            HStack{
                Text("Loai tien te")
                Spacer()
                Text("VND - Vietnamese Dong")
            }
            .foregroundStyle(.ccPrimary)
            .pickerStyle(.navigationLink)
            .modifier(RegularTextModifier(textSize: 16))
            Text("1 USD = 25.000 VND")
                .modifier(RegularTextModifier(textSize: 15))
                .foregroundStyle(.gray)
            TextField("Enter amount", text: .constant("25,000"))
                .modifier(DemiBoldTextModifier(textSize: 25))
            VStack(alignment: .leading){
                Text("Lần cập nhật gần đây nhất: ")
                Text("Lần cập nhật tiếp theo: ")
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
        .redacted(reason: .placeholder)
        .shimmering()
    }
}

#Preview {
    ExchangeWindowPlaceHolder()
}
