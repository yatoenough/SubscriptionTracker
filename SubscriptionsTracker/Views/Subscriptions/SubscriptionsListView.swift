//
//  SubscriptionsListView.swift
//  SubscriptionsTracker
//
//  Created by Nikita Shyshkin on 02/08/2025.
//

import SwiftData
import SwiftUI

struct SubscriptionsListView: View {
	@Environment(SubscriptionsViewModel.self) private var subscriptionsViewModel
	
	@State private var isAddViewPresented = false

	var body: some View {
		List(subscriptionsViewModel.subscriptions) { subscription in
			Text(
				"\(subscription.name), \(subscription.price.formatted(.currency(code: subscription.currencyCode))), \(subscription.startDate)"
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
