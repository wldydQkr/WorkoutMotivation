//
//  MotivationWidgetLiveActivity.swift
//  MotivationWidget
//
//  Created by 박지용 on 6/12/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MotivationWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MotivationWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MotivationWidgetAttributes.self) { context in
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

extension MotivationWidgetAttributes {
    fileprivate static var preview: MotivationWidgetAttributes {
        MotivationWidgetAttributes(name: "World")
    }
}

extension MotivationWidgetAttributes.ContentState {
    fileprivate static var smiley: MotivationWidgetAttributes.ContentState {
        MotivationWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MotivationWidgetAttributes.ContentState {
         MotivationWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MotivationWidgetAttributes.preview) {
   MotivationWidgetLiveActivity()
} contentStates: {
    MotivationWidgetAttributes.ContentState.smiley
    MotivationWidgetAttributes.ContentState.starEyes
}
