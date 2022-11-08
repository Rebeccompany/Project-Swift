//
//  ContentView.swift
//  
//
//  Created by Rebecca Mello on 07/11/22.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        Button("Schedule Notification") {
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = "Piu!!"
            content.body = "Vem estudar Nome do Baralho"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3.0, repeats: false)
            
            let request = UNNotificationRequest(identifier: "identifier", content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
