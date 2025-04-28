//
//  TrainingActivityWIdgetLiveActivity.swift
//  TrainingActivityWIdget
//
//  Created by Maxim Dmitrochenko on 4/27/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TrainingActivityWIdgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TrainingActivityWIdgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TrainingActivityWIdgetAttributes.self) { context in
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

extension TrainingActivityWIdgetAttributes {
    fileprivate static var preview: TrainingActivityWIdgetAttributes {
        TrainingActivityWIdgetAttributes(name: "World")
    }
}

extension TrainingActivityWIdgetAttributes.ContentState {
    fileprivate static var smiley: TrainingActivityWIdgetAttributes.ContentState {
        TrainingActivityWIdgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TrainingActivityWIdgetAttributes.ContentState {
         TrainingActivityWIdgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TrainingActivityWIdgetAttributes.preview) {
   TrainingActivityWIdgetLiveActivity()
} contentStates: {
    TrainingActivityWIdgetAttributes.ContentState.smiley
    TrainingActivityWIdgetAttributes.ContentState.starEyes
}
