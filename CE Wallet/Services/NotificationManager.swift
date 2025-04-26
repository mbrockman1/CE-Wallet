//
//  NotificationManager.swift
//  CEWallet
//
//  Created by Michael Brockman on 4/23/25.
//


import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func requestAuthorization() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if let error = error {
                    print("Notification auth error:", error)
                }
            }
    }

    func scheduleExpirationNotification(for entry: LicenseEntry) {
        let content = UNMutableNotificationContent()
        content.title = "\(entry.title) expires soon"
        content.body = "Your \(entry.title) will expire on " +
            DateFormatter.localizedString(
                from: entry.expirationDate,
                dateStyle: .medium,
                timeStyle: .none
            ) + "."
        content.sound = .default

        // 30 days before expiration
        let notifyDate = Calendar.current
            .date(byAdding: .day, value: -30, to: entry.expirationDate) ?? entry.expirationDate
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: notifyDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)

        let request = UNNotificationRequest(
            identifier: entry.id.uuidString,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Scheduling error:", error)
            }
        }
    }

    func cancelNotification(for entry: LicenseEntry) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: [entry.id.uuidString]
            )
    }
}
