//
//  AddSubscriptionView.swift
//  SubscriptionsTracker
//
//  Created by Nikita Shyshkin on 04/08/2025.
//

import SwiftUI

struct AddSubscriptionView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(SubscriptionsViewModel.self) private var subscriptionsViewModel

	@State private var name = ""
	@State private var price = 0.0
	@State private var startDate = Date()
	@State private var billingCycle = BillingCycle.monthly
	@State private var currencyCode = "USD"
	
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
			.navigationTitle("Add Subscription")
			.toolbar {
				ToolbarItem(placement: .confirmationAction) {
					Button("Add") {
						saveSubscription()

						dismiss()
					}
					.disabled(!isSubscriptionDataValid)
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
		subscriptionsViewModel.addSubscription(
			name: name,
			price: price,
			startDate: startDate,
			billingCycle: billingCycle,
			currencyCode: currencyCode
		)
	}
}

#Preview(traits: .modifier(PreviewDataModifier())) {
	AddSubscriptionView()
}
