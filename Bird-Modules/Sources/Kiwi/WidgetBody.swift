//
//  WidgetContent.swift
//  Project-Bird
//
//  Created by Rebecca Mello on 12/12/22.
//

import Foundation
import WidgetKit
import Models

struct WidgetBody: TimelineEntry {
    var date: Date
    var widgetData: WidgetDataModel
}

struct WidgetDataModel: Codable {
    var deck: [Deck]
}
