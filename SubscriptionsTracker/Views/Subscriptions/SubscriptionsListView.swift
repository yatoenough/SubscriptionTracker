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
		List {
			ForEach(sortedSubscriptions) { subscription in
				SubscriptionView(subscription: subscription)
					.listRowSeparator(.hidden)
					.listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
					.swipeActions(edge: .trailing, allowsFullSwipe: true) {
						Button(role: .destructive) {
							subscriptionsViewModel.deleteSubscription(subscription)
						} label: {
							Label("delete", systemImage: "trash")
						}
						
						Button {
							subscriptionToEdit = subscription
						} label: {
							Label("edit", systemImage: "pencil")
						}
						.tint(.orange)
					}
			}
		}
		.listStyle(.plain)
		.navigationTitle(Text("subscriptions"))
		.toolbar {
			Button {
				isSubscriptionFormPresented = true
			} label: {
				Image(systemName: "plus.circle.fill")
					.font(.title2)
			}
		}
		.sheet(isPresented: $isSubscriptionFormPresented) {
			SubscriptionFormView()
		}
		.sheet(item: $subscriptionToEdit) { subscription in
			SubscriptionFormView(subscriptionToEdit: subscription)
		}
		.alert(Text("notifications_permission_denied_title"), isPresented: .constant(subscriptionsViewModel.isNotificationsPermissionDenied)) {
			Button("OK") {}
		} message: {
			Text("notifications_permission_denied_message")
		}
	}
}

#Preview(traits: .modifier(PreviewDataModifier())) {
	NavigationStack {
		SubscriptionsListView()
	}
}
