//
//  Subscription.swift
//  SubscriptionsTracker
//
//  Created by Nikita Shyshkin on 02/08/2025.
//

import Foundation
import SwiftData

enum BillingCycle: String, CaseIterable, Codable {
	case daily = "Daily"
	case weekly = "Weekly"
	case monthly = "Monthly"
	case yearly = "Yearly"
}

@Model
class Subscription {
	var name: String
	var price: Double
	var startDate: Date
	var BillingCycle: BillingCycle
	var currencyCode: String

	init(
		name: String,
		price: Double,
		startDate: Date,
		BillingCycle: BillingCycle,
		currencyCode: String
	) {
		self.name = name
		self.price = price
		self.startDate = startDate
		self.BillingCycle = BillingCycle
		self.currencyCode = currencyCode
	}

	var nextBillingDate: Date {
		let calendar = Calendar.current
		let today = calendar.startOfDay(for: .now)

		if startDate > today {
			return startDate
		}
		
		var components: DateComponents

		switch BillingCycle {
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
}
