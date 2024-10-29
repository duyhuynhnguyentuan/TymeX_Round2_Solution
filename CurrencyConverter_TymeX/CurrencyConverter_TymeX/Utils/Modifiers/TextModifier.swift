//
//  TextModifier.swift
//  CurrencyConverter_TymeX
//
//  Created by Huynh Nguyen Tuan Duy on 27/10/24.
//

import SwiftUI

struct BoldTextModifier: ViewModifier {
    let textSize:CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("AvenirNext-Bold", size: textSize))
            
    }
}
struct RegularTextModifier: ViewModifier {
    let textSize:CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("AvenirNext-Regular", size: textSize))
        
    }
}

struct DemiBoldTextModifier: ViewModifier {
    let textSize:CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("AvenirNext-DemiBold", size: textSize))
        
    }
}
