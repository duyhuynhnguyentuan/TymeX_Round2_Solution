//
//  CurencyGraphWidgetLiveActivity.swift
//  CurencyGraphWidget
//
//  Created by Huynh Nguyen Tuan Duy on 29/10/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CurencyGraphWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct CurencyGraphWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CurencyGraphWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension CurencyGraphWidgetAttributes {
    fileprivate static var preview: CurencyGraphWidgetAttributes {
        CurencyGraphWidgetAttributes(name: "World")
    }
}

extension CurencyGraphWidgetAttributes.ContentState {
    fileprivate static var smiley: CurencyGraphWidgetAttributes.ContentState {
        CurencyGraphWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: CurencyGraphWidgetAttributes.ContentState {
         CurencyGraphWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: CurencyGraphWidgetAttributes.preview) {
   CurencyGraphWidgetLiveActivity()
} contentStates: {
    CurencyGraphWidgetAttributes.ContentState.smiley
    CurencyGraphWidgetAttributes.ContentState.starEyes
}
