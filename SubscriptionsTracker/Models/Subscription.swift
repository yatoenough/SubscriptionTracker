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
}
