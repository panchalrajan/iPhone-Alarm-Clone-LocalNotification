import UIKit
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private let notificationCenter = UNUserNotificationCenter.current()

    private init() {}

    func requestForNotificationPermission() {
        notificationCenter.requestAuthorization(options: [.badge, .sound, .alert]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    func checkForNotificationPermission(completion: @escaping (Bool) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                print("Authorized")
                completion(true)
            default:
                print("Not Authorized")
                completion(false)
            }
        }
    }

    func removeLocalNotification(for alarm: Alarm) {
        var identifiers: [String] = []
        if alarm.getRepeatation().isEmpty {
            identifiers.append(alarm.getID())
        } else {
            identifiers = alarm.getRepeatation().map { "\(alarm.getID())-\($0.abbreviatedName)" }
        }
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
        print("Notifications removed for Alarm with ID: \(alarm.getID())")
    }

    func scheduleLocalNotification(for alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = alarm.getLabel()
        content.sound = .default
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: alarm.getTime())
        
        if alarm.getRepeatation().isEmpty {
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: alarm.getID(), content: content, trigger: trigger)
    
            notificationCenter.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                } else {
                    print("Notification scheduled successfully for \(dateComponents)")
                }
            }
        } else {
            for day in alarm.getRepeatation() {
                var triggerComponents = dateComponents
                triggerComponents.weekday = day.weekdayValue
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
                let request = UNNotificationRequest(identifier: "\(alarm.getID())-\(day.abbreviatedName)", content: content, trigger: trigger)
                
                notificationCenter.add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    } else {
                        print("Notification scheduled successfully for  \(triggerComponents)")
                    }
                }
            }
        }
    }

    func scheduleSnoozedAlarm(for alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = alarm.getLabel()
        content.sound = .default
        
        let calendar = Calendar.current
        let snoozeTime = calendar.date(byAdding: .minute, value: alarm.getSnoozeCount() + 1, to: alarm.getTime())!
        let dateComponents = calendar.dateComponents([.hour, .minute], from: snoozeTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: alarm.getID(), content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling snoozed alarm: \(error)")
            } else {
                alarm.setSnoozeCount(alarm.getSnoozeCount() + 1)
                print("Snoozed alarm scheduled successfully at \(dateComponents)")
            }
        }
    }
    
    func printAllPendingNotifications() {
            notificationCenter.getPendingNotificationRequests { requests in
                if requests.isEmpty {
                    print("No pending notifications.")
                } else {
                    print("Pending Notifications:")
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    for request in requests {
                        if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                            let nextTriggerDate = trigger.nextTriggerDate()
                            let formattedDate = dateFormatter.string(from: nextTriggerDate ?? Date())
                            print("Identifier: \(request.identifier), Date: \(formattedDate)")
                        }
                    }
                }
            }
        }
    
    func deleteAllPendingNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        print("All pending notifications have been deleted.")
    }
}
