//
//  SubscriptionsListView.swift
//  SubscriptionsTracker
//
//  Created by Nikita Shyshkin on 02/08/2025.
//

import SwiftData
import SwiftUI

struct SubscriptionsListView: View {
	@State private var isAddViewPresented = false
	
	@Query private var subscriptions: [Subscription]

	private var sortedSubscriptions: [Subscription] {
		subscriptions.sorted { $0.nextBillingDate < $1.nextBillingDate }
	}

	var body: some View {
		List(sortedSubscriptions) { subscription in
			Text(
				"\(subscription.name), \(subscription.price.formatted(.currency(code: subscription.currencyCode))), \(subscription.nextBillingDate)"
			)
		}
		.toolbar {
			Button("Add subscription") {
				isAddViewPresented = true
			}
		}
		.sheet(isPresented: $isAddViewPresented) {
			AddSubscriptionView()
		}
	}
}

#Preview(traits: .modifier(PreviewDataModifier())) {
    NavigationStack {
        SubscriptionsListView()
    }
}
