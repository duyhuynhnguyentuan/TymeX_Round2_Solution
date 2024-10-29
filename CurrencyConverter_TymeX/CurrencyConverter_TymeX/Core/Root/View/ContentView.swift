//
//  ContentView.swift
//  CurrencyConverter_TymeX
//
//  Created by Huynh Nguyen Tuan Duy on 27/10/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var monitor = NetworkMonitor()
    @State private var showAlert = false
    var body: some View {
        ResponsiveView  { _ in
            //checking for network connection
            if monitor.isConnected {
                CCTabView()
            } else {
                VStack{
                    Image(systemName: "wifi.slash")
                        .font(.largeTitle)
                        .foregroundStyle(.red)
                    Text("Không có kết nối internet")
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .onAppear {
                    showAlert = true
                }
                .alert(isPresented: $showAlert, content: {
                    return Alert(title: Text("Không có kêt nối mạng"), message: Text("Hãy thử kết nối đến wifi hoặc dữ liệu di động"), dismissButton: .default(Text("Cancel")))
                })
            }
        }
    }
}

#Preview {
    ContentView()
}
