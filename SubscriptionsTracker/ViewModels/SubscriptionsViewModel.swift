//
//  SubscriptionsViewModel.swift
//  SubscriptionsTracker
//
//  Created by Nikita Shyshkin on 02/08/2025.
//

import Foundation
import SwiftData
import UserNotifications

@MainActor
@Observable
class SubscriptionsViewModel {
	private var modelContext: ModelContext
	private let notificationsService: NotificationsService

	init(modelContext: ModelContext, notificationsService: NotificationsService) {
		self.modelContext = modelContext
		self.notificationsService = notificationsService
	}
	
	func addSubscription(
		name: String,
		price: Double,
		startDate: Date,
		billingCycle: BillingCycle,
		currencyCode: String
	) {
		let newSubscription = Subscription(
			name: name,
			price: price,
			startDate: startDate,
			billingCycle: billingCycle,
			currencyCode: currencyCode
		)

		modelContext.insert(newSubscription)
		scheduleNotification(for: newSubscription)
	}

	func updateSubscription(
		_ subscription: Subscription,
		name: String,
		price: Double,
		startDate: Date,
		billingCycle: BillingCycle,
		currencyCode: String
	) {
		subscription.name = name
		subscription.price = price
		subscription.startDate = startDate
		subscription.billingCycle = billingCycle
		subscription.currencyCode = currencyCode
		
		notificationsService.deleteNotification(withId: subscription.notificationId)
		scheduleNotification(for: subscription)
	}

	func deleteSubscription(_ subscription: Subscription) {
		notificationsService.deleteNotification(withId: subscription.notificationId)
		modelContext.delete(subscription)
	}
	
	private func scheduleNotification(for subscription: Subscription) {
		let notificationDate = Calendar.current.date(byAdding: .day, value: -1, to: subscription.nextBillingDate)!
		var components: Set<Calendar.Component> = []
		
		switch subscription.billingCycle {
			case .weekly:
				components = [.weekday]
			case .monthly:
				components = [.day]
			case .yearly:
				components = [.month, .day]
			case .daily:
				components = [.hour, .minute]
		}
		
		var triggerDateComponents = Calendar.current.dateComponents(components, from: notificationDate)
		
		triggerDateComponents.minute = 0
		triggerDateComponents.hour = 12
		
		let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: true)
		
		let notificationData = NotificationData(
			id: subscription.notificationId,
			title: "\(subscription.name) subscription",
			subtitle: "\(subscription.name) subscription is due tomorrow",
			sound: .default,
			trigger: trigger
		)
		
		notificationsService.scheduleNotification(notificationData: notificationData)
	}
}
