//
//  PlantNotification.swift
//  Planto
//
//  Created by Rana on 04/05/1447 AH.
//



import Foundation
import UserNotifications

final class PlantNotification: NSObject, UNUserNotificationCenterDelegate {
    static let shared = PlantNotification()

    // طلب إذن الإشعارات
    func askPermission() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                print("✅ Notifications allowed")
            } else {
                print("❌ Notifications denied")
            }
        }
    }

    // جدولة الإشعار
    func send(plant: String, every: String) {
        let seconds = getSeconds(for: every)
        guard seconds >= 1 else { return }

        let content = UNMutableNotificationContent()
        content.title = "Time to water 🌿"
        content.body = "Don't forget to water \(plant)"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Notification error: \(error)")
            } else {
                print("✅ Notification scheduled for \(plant) in \(seconds) seconds")
            }
        }
    }

    // تحويل النص إلى ثوانٍ
    private func getSeconds(for text: String) -> Double {
        switch text.lowercased() {
        case "every day":
            return 10  // 10 ثواني للتجربة
        case "every 2 days":
            return 2 * 86400
        case "every 3 days":
            return 3 * 86400
        case "once a week":
            return 7 * 86400
        case "every 10 days":
            return 10 * 86400
        case "every 2 weeks":
            return 14 * 86400
        default:
            return 86400
        }
    }
}
