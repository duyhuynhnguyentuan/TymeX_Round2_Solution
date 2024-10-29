//
//  WidgetView.swift
//  CurrencyConverter_TymeX
//
//  Created by Huynh Nguyen Tuan Duy on 27/10/24.
//


import SwiftUI
import AVKit

struct WidgetView: View {
    var url = Bundle.main.url(forResource: "demoWidget", withExtension: "mov")!
    @State private var player = AVPlayer()

    var body: some View {
        VStack {
            Text("Cách Thêm Widget")
                .modifier(BoldTextModifier(textSize: 30))
                .foregroundStyle(.ccPrimary)
            VideoPlayer(player: player)
                .onAppear {
                    player.replaceCurrentItem(with: AVPlayerItem(url: url))
                    player.play()
                }
                .padding(.horizontal)
                .padding(.top, -10)
        }
    }
}

#Preview {
    WidgetView()
}


#Preview {
    WidgetView()
}
