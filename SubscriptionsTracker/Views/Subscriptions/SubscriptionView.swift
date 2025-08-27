//
//  SubscriptionView.swift
//  SubscriptionsTracker
//
//  Created by Nikita Shyshkin on 12/08/2025.
//

import SwiftUI

struct SubscriptionView: View {
	let subscription: Subscription
	
	var formatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd/MM/yyyy"
		return formatter
	}

	var body: some View {
		VStack {
			HStack(alignment: .center) {
				VStack(alignment: .leading) {
					Text(subscription.name)
						.font(.headline)
						.bold()
				}

				Spacer()

				VStack(alignment: .trailing) {
					Text(subscription.price.formatted(.currency(code: subscription.currencyCode)))
						.font(.headline)
						.bold()
					
					Text(subscription.billingCycle.rawValue.capitalized)
						.font(.caption)
						.foregroundStyle(.secondary)
				}
			}
			
			ProgressView(
				value: min(1, Double(Calendar.current.dateComponents([.day], from: subscription.startDate, to: .now).day ?? 0) / 30),
				total: 1
			)
			.progressViewStyle(.linear)
			.tint(.accentColor)
			
			HStack {
				VStack(alignment: .leading) {
					Text("Start Date")
						.font(.caption)
						.foregroundStyle(.secondary)
					Text(formatter.string(from: subscription.startDate))
						.font(.subheadline)
				}
				
				Spacer()
				
				VStack(alignment: .trailing) {
					Text("Next Payment")
						.font(.caption)
						.foregroundStyle(.secondary)
					Text(formatter.string(from: subscription.nextBillingDate))
						.font(.subheadline)
				}
			}
		}
		.padding()
		.background(
			RoundedRectangle(cornerRadius: 15)
				.foregroundStyle(.regularMaterial)
		)
	}
}

#Preview {
	SubscriptionView(subscription: Subscription.example)
}
