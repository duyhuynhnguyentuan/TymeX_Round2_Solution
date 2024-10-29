//
//  ResponsiveView.swift
//  CurrencyConverter_TymeX
//
//  Created by Huynh Nguyen Tuan Duy on 27/10/24.
//

import Foundation

import SwiftUI


// MARK: - Inject into environment
struct PropertiesKey: EnvironmentKey {
    static let defaultValue = Properties(isLandscape: false, isIpad: false, isSplit: false, isMaxSplit: false, isAdoptable: false, size: .zero)
}

extension EnvironmentValues {
    var properties: Properties {
        get { self[PropertiesKey.self] }
        set { self[PropertiesKey.self] = newValue }
    }
}


//MARK: - Utilities to handle different screen sizes
struct ResponsiveView<Content: View>: View {
    var content: (Properties) -> Content
    init(@ViewBuilder content: @escaping (Properties) -> Content) {
        self.content = content
    }

    @State private var properties = Properties(isLandscape: false, isIpad: false, isSplit: false, isMaxSplit: false, isAdoptable: false, size: .zero)

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let isLandscape = size.width > size.height
            let isIpad = UIDevice.current.userInterfaceIdiom == .pad
            let isMaxSplit = isSplit() && size.width < 400
            let isAdoptable = isIpad && (isLandscape ? !isMaxSplit : !isSplit())

            content(properties)
                .environment(\.properties, properties)
                .onAppear {
                    updateProperties(size: size, isLandscape: isLandscape, isIpad: isIpad, isMaxSplit: isMaxSplit, isAdoptable: isAdoptable)
                }
                .onChange(of: size) { _ , newSize in
                    updateProperties(size: newSize, isLandscape: newSize.width > newSize.height, isIpad: isIpad, isMaxSplit: isMaxSplit, isAdoptable: isAdoptable)
                }
        }
    }

    func updateProperties(size: CGSize, isLandscape: Bool, isIpad: Bool, isMaxSplit: Bool, isAdoptable: Bool) {
        properties = Properties(isLandscape: isLandscape, isIpad: isIpad, isSplit: isSplit(), isMaxSplit: isMaxSplit, isAdoptable: isAdoptable, size: size)
    }

    func isSplit() -> Bool {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return false
        }
        return screen.windows.first?.frame.size != screen.screen.bounds.size
    }
}

struct Properties {
    var isLandscape: Bool
    var isIpad: Bool
    var isSplit: Bool
    // MARK: If the app reduces more than 1/3 in split mode in Ipad
    var isMaxSplit: Bool
    var isAdoptable: Bool
    var size: CGSize
}
//#Preview {
//    ContentView()
//}
