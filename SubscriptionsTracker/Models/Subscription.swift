//
//  Subscription.swift
//  SubscriptionsTracker
//
//  Created by Nikita Shyshkin on 02/08/2025.
//

import Foundation
import SwiftData
import SwiftUI

enum BillingCycle: String, CaseIterable, Codable {
	case daily = "daily"
	case weekly = "weekly"
	case monthly = "monthly"
	case yearly = "yearly"
	
	var localized: LocalizedStringKey {
		LocalizedStringKey(self.rawValue)
	}
}

@Model
class Subscription {
	var name: String
	var price: Double
	var startDate: Date
	var billingCycle: BillingCycle
	var currencyCode: String
	var notificationId = UUID()

	init(
		name: String,
		price: Double,
		startDate: Date,
		billingCycle: BillingCycle,
		currencyCode: String
	) {
		self.name = name
		self.price = price
		self.startDate = startDate
		self.billingCycle = billingCycle
		self.currencyCode = currencyCode
	}

	var nextBillingDate: Date {
		let calendar = Calendar.current
		let today = calendar.startOfDay(for: .now)

		if startDate > today {
			return startDate
		}
		
		var components: DateComponents

		switch billingCycle {
		case .daily:
			return today
		case .weekly:
			components = calendar.dateComponents([.weekday], from: startDate)
		case .monthly:
			components = calendar.dateComponents([.day], from: startDate)
		case .yearly:
			components = calendar.dateComponents([.month, .day], from: startDate)
		}
		
		return calendar.nextDate(after: today, matching: components, matchingPolicy: .nextTime, direction: .forward) ?? today
	}
	
	var lastBillingDate: Date {
		let calendar = Calendar.current
		let today = calendar.startOfDay(for: .now)

		if startDate > today {
			return startDate
		}

		var components: DateComponents
		switch billingCycle {
		case .daily:
			return today
		case .weekly:
			components = calendar.dateComponents([.weekday], from: startDate)
		case .monthly:
			components = calendar.dateComponents([.day], from: startDate)
		case .yearly:
			components = calendar.dateComponents([.month, .day], from: startDate)
		}
		
		return calendar.nextDate(after: today, matching: components, matchingPolicy: .nextTime, direction: .backward) ?? today
	}

	var progress: Double {
		let now = Date()
		guard startDate <= now else { return 0 }

		let calendar = Calendar.current
		let totalDaysInCycle: Double
		
		let nextDate = nextBillingDate
		let lastDate = lastBillingDate

		totalDaysInCycle = Double(calendar.dateComponents([.day], from: lastDate, to: nextDate).day ?? 0)
		let daysPassed = Double(calendar.dateComponents([.day], from: lastDate, to: now).day ?? 0)

		return min(1, max(0, daysPassed / totalDaysInCycle))
	}

	#if DEBUG
	@MainActor
	static let example: Subscription = .init(
		name: "Demo",
		price: 10.0,
		startDate: Date(),
		billingCycle: .monthly,
		currencyCode: "USD"
	)
	#endif
}
