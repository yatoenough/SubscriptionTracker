//
//  SubscriptionsListView.swift
//  SubscriptionsTracker
//
//  Created by Nikita Shyshkin on 02/08/2025.
//

import SwiftData
import SwiftUI

struct SubscriptionsListView: View {
	@Environment(\.modelContext) var modelContext
	@Environment(SubscriptionsViewModel.self) var subscriptionsViewModel

	var body: some View {
		List(subscriptionsViewModel.subscriptions) { subscription in
			Text(
				"\(subscription.name), \(subscription.price)\(subscription.currencyCode), \(subscription.startDate.formatted())"
			)
		}
		.toolbar {
			Button("Add example") {
				subscriptionsViewModel.addSubscription(
					name: "Demo",
					price: 2,
					startDate: Date(),
					billingCycle: .monthly,
					currencyCode: "USD"
				)
			}
		}
	}
}

#warning("Fix me")
#Preview {
	let container: ModelContainer
	
	do {
		container = try ModelContainer(
			for: Subscription.self,
			configurations: ModelConfiguration(isStoredInMemoryOnly: true)
		)

		return NavigationStack {
			SubscriptionsListView()
		}
		.environment(SubscriptionsViewModel(modelContext: container.mainContext))
		.modelContainer(container)
	} catch {
		print(error.localizedDescription)
	}
	
	return EmptyView()
}
