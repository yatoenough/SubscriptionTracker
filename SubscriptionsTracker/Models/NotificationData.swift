//
//  NotificationData.swift
//  SubscriptionsTracker
//
//  Created by Nikita Shyshkin on 12/08/2025.
//

import Foundation
import UserNotifications

struct NotificationData {
	let id: UUID
	let title: String
	let subtitle: String
	let sound: UNNotificationSound
	let trigger: UNNotificationTrigger
}
