//
//  Provider.swift
//  
//
//  Created by Rebecca Mello on 12/12/22.
//

import WidgetKit
import SwiftUI
import Intents
import Models
import Storage

struct Provider: TimelineProvider {
    
    var date: Date
        
    func getSnapshot(in context: Context, completion: @escaping (WidgetBody) -> ()){
        let loadingData = WidgetBody(date: Date(), widgetData: WidgetDataModel(deck: [Deck(id: UUID(), name: "", icon: "", color: .red, collectionId: UUID(), cardsIds: [], category: .others, storeId: "", description: "", ownerId: "")]))
        completion(loadingData)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetBody>) -> Void) {
        getData { modelData in
            let date = Date()
            let data = WidgetBody(date: date, widgetData: modelData)
            
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: date)
            let timeline = Timeline(entries: [data], policy: .after(nextUpdate!))
            completion(timeline)
        }
    }
    
    func getData(completion: @escaping (WidgetDataModel) -> Void) {
        
    }
    
    func placeholder(in context: Context) -> WidgetBody {
        WidgetBody(date: .init(), widgetData: .init(deck: []))
    }
    
    @main
    struct SpixiiWidget: Widget {
        let kind: String = "HelloWidget"
        
        var body: some WidgetConfiguration {
            StaticConfiguration(kind: kind, provider: Provider()) { data in
                WidgetView(data: data)
            }
            .configurationDisplayName("Última mensagem recebida")
            .description("Saiba da última mensagem recebida no Hello")
        }
    }
}

class WidgetModel: ObservableObject {
//    @Dependency 
}
