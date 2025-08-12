//
//  SubscriptionFormView.swift
//  SubscriptionsTracker
//
//  Created by Nikita Shyshkin on 04/08/2025.
//

import SwiftUI

struct SubscriptionFormView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(SubscriptionsViewModel.self) private var subscriptionsViewModel

	let subscriptionToEdit: Subscription?

	@State private var name = ""
	@State private var price = 0.0
	@State private var startDate = Date()
	@State private var billingCycle = BillingCycle.monthly
	@State private var currencyCode = "USD"

	init(subscriptionToEdit: Subscription? = nil) {
		self.subscriptionToEdit = subscriptionToEdit

		if let subscriptionToEdit {
			_name = State(initialValue: subscriptionToEdit.name)
			_price = State(initialValue: subscriptionToEdit.price)
			_startDate = State(initialValue: subscriptionToEdit.startDate)
			_billingCycle = State(initialValue: subscriptionToEdit.billingCycle)
			_currencyCode = State(initialValue: subscriptionToEdit.currencyCode)
		}
	}

	private var navigationTitle: String {
		subscriptionToEdit == nil ? "Add Subscription" : "Edit Subscription"
	}

	private var isSubscriptionDataValid: Bool { validateSubscription() }

	var body: some View {
		NavigationStack {
			Form {
				Section("Subscription Details") {
					TextField("Name", text: $name)

					TextField(
						"Price",
						value: $price,
						format: .currency(code: currencyCode)
					)
					.keyboardType(.decimalPad)

					Picker("Currency", selection: $currencyCode) {
						ForEach(Locale.commonISOCurrencyCodes, id: \.self) {
							code in
							Text(code)
						}
					}
				}

				Section("Billing") {
					DatePicker(
						"Start Date",
						selection: $startDate,
						displayedComponents: .date
					)

					Picker("Billing Cycle", selection: $billingCycle) {
						ForEach(BillingCycle.allCases, id: \.self) { cycle in
							Text(cycle.rawValue)
								.tag(cycle)
						}
					}
				}
			}
			.navigationTitle(navigationTitle)
			.toolbar {
				ToolbarItem(placement: .confirmationAction) {
					Button("Save") {
						saveSubscription()

						dismiss()
					}
					.disabled(isSubscriptionDataValid == false)
				}

				ToolbarItem(placement: .cancellationAction) {
					Button("Cancel", role: .cancel) {
						dismiss()
					}
				}
			}
		}
	}

	private func validateSubscription() -> Bool {
		guard !name.isEmpty else { return false }
		guard price > 0 else { return false }

		return true
	}

	private func saveSubscription() {
		if let subscriptionToEdit {
			subscriptionsViewModel.updateSubscription(
				subscriptionToEdit,
				name: name,
				price: price,
				startDate: startDate,
				billingCycle: billingCycle,
				currencyCode: currencyCode
			)
			
			return
		}

		subscriptionsViewModel.addSubscription(
			name: name,
			price: price,
			startDate: startDate,
			billingCycle: billingCycle,
			currencyCode: currencyCode
		)
	}
}

#Preview("Add subscription", traits: .modifier(PreviewDataModifier())) {
	SubscriptionFormView()
}

#Preview("Edit subscription", traits: .modifier(PreviewDataModifier())) {
	SubscriptionFormView(subscriptionToEdit: Subscription.example)
}
