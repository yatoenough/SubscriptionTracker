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
	var subscriptions = [Subscription]()

	init(modelContext: ModelContext) {
		self.modelContext = modelContext
	}

	func fetchSubscriptions() {
		do {
			let descriptor = FetchDescriptor<Subscription>(sortBy: [
				SortDescriptor(\Subscription.name)
			])
			subscriptions = try modelContext.fetch(descriptor)
		} catch {
			print("Fetch failed")
		}
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

		fetchSubscriptions()
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

		fetchSubscriptions()
	}

	func deleteSubscription(_ subscription: Subscription) {
		modelContext.delete(subscription)

		fetchSubscriptions()
	}
}
