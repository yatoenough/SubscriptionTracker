//
//  SubscriptionsListView.swift
//  SubscriptionsTracker
//
//  Created by Nikita Shyshkin on 02/08/2025.
//

import SwiftData
import SwiftUI

struct SubscriptionsListView: View {
	@State private var isSubscriptionFormPresented = false
	@State private var subscriptionToEdit: Subscription? = nil

	@Query private var subscriptions: [Subscription]

	@Environment(SubscriptionsViewModel.self) private var subscriptionsViewModel

	private var sortedSubscriptions: [Subscription] {
		subscriptions.sorted { $0.nextBillingDate < $1.nextBillingDate }
	}

	var body: some View {
		ScrollView {
			ForEach(sortedSubscriptions) { subscription in
				SubscriptionView(subscription: subscription)
					.overlay(alignment: .topTrailing) {
						Menu {
							Button {
								subscriptionToEdit = subscription
							} label: {
								Label("Edit", systemImage: "pencil")
									.tint(.orange)
							}
							
							Button(role: .destructive) {
								subscriptionsViewModel.deleteSubscription(
									subscription
								)
							} label: {
								Label("Delete", systemImage: "trash")
							}
						} label: {
							Image(systemName: "ellipsis")
								.padding(3)
						}
						.buttonBorderShape(.circle)
						.buttonStyle(.bordered)
					}
			}
		}
		.toolbar {
			Button {
				isSubscriptionFormPresented = true
			} label: {
				Image(systemName: "plus")
			}
		}
		.sheet(isPresented: $isSubscriptionFormPresented) {
			SubscriptionFormView()
		}
		.sheet(item: $subscriptionToEdit) { subscription in
			SubscriptionFormView(subscriptionToEdit: subscription)
		}
	}
}

#Preview(traits: .modifier(PreviewDataModifier())) {
	NavigationStack {
		SubscriptionsListView()
	}
}
