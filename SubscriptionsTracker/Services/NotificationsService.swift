//
//  NotificationsService.swift
//  SubscriptionsTracker
//
//  Created by Nikita Shyshkin on 12/08/2025.
//

@preconcurrency import UserNotifications

final class NotificationsService: Sendable {
	private let center = UNUserNotificationCenter.current()

	func requestAuthorization(options: UNAuthorizationOptions) async -> Bool {
		return await withCheckedContinuation { continuation in
			center.requestAuthorization(options: options) { success, error in
				if success {
					continuation.resume(returning: success)
				} else if let error {
					print("Error requesting authorization: \(error)")
					continuation.resume(returning: false)
				}
			}
		}
	}

	func scheduleNotification(notificationData: NotificationData) {
		let content = UNMutableNotificationContent()

		content.title = notificationData.title
		content.subtitle = notificationData.subtitle
		content.sound = notificationData.sound

		let request = UNNotificationRequest(
			identifier: notificationData.id.uuidString,
			content: content,
			trigger: notificationData.trigger
		)

		center.add(request)
	}

	func deleteNotification(withId id: UUID) {
		center.removePendingNotificationRequests(withIdentifiers: [id.uuidString])
	}
}
