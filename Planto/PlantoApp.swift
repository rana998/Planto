//
//  PlantoApp.swift
//  Planto
//
//  Created by Rana on 01/05/1447 AH.
//

import SwiftUI

@main
struct PlantoApp: App {
    init() {
            // ✅ طلب إذن الإشعارات عند فتح التطبيق
            PlantNotification.shared.askPermission()
        }
    var body: some Scene {
        WindowGroup {
            TodayReminderView()
                .environment(\.colorScheme, .dark)

        }
    }
}
