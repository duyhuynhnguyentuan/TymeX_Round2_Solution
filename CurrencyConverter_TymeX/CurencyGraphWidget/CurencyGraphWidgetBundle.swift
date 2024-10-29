//
//  CurencyGraphWidgetBundle.swift
//  CurencyGraphWidget
//
//  Created by Huynh Nguyen Tuan Duy on 29/10/24.
//

import WidgetKit
import SwiftUI

@main
struct CurencyGraphWidgetBundle: WidgetBundle {
    var body: some Widget {
        CurencyGraphWidget()
        CurencyGraphWidgetControl()
        CurencyGraphWidgetLiveActivity()
    }
}
