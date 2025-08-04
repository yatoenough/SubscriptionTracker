//
//  SubscriptionsViewModel.swift
//  SubscriptionsTracker
//
//  Created by Nikita Shyshkin on 02/08/2025.
//

import Foundation
import SwiftData

@MainActor
@Observable
class SubscriptionsViewModel {
	var modelContext: ModelContext

	init(modelContext: ModelContext) {
		self.modelContext = modelContext
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
			BillingCycle: billingCycle,
			currencyCode: currencyCode
		)

		modelContext.insert(newSubscription)
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
		subscription.BillingCycle = billingCycle
		subscription.currencyCode = currencyCode
	}

	func deleteSubscription(_ subscription: Subscription) {
		modelContext.delete(subscription)
	}
}
