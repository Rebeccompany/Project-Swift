//
//  Project_Bird_Widget.swift
//  Project-Bird-Widget
//
//  Created by Claudia Fiorentino on 12/12/22.
//

import WidgetKit
import SwiftUI
import Intents
import Kiwi

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> WidgetBody {
        WidgetBody(date: Date(), widgetData: WidgetDataModel())
    }
}
