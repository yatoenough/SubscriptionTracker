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
			HStack(alignment: .midline) {
				VStack {
					Text(subscription.name)
						.font(.title)
						.bold()
						.alignmentGuide(.midline) { d in
							d[VerticalAlignment.center]
						}
				}

				Spacer()

				VStack {
					Text("\(subscription.price.formatted(.currency(code: subscription.currencyCode)))")
					.bold()
					.alignmentGuide(.midline) { d in
						d[VerticalAlignment.center]
					}
					
					Text(subscription.billingCycle.rawValue.capitalized)
						.font(.caption)
						
				}
			}
			.padding()
			
			HStack {
				VStack {
					Text("Start date")
					Text(formatter.string(from: subscription.startDate))
						.font(.callout)
				}
				
				Spacer()
				
				VStack {
					Text("Next payment")
					Text(formatter.string(from: subscription.nextBillingDate))
						.font(.callout)
				}
			}
			.font(.footnote)
			.padding()
		}
		.background(
			RoundedRectangle(cornerRadius: 10)
				.foregroundStyle(.regularMaterial)
		)
		.padding()
	}
}

#Preview {
	SubscriptionView(subscription: Subscription.example)
}
