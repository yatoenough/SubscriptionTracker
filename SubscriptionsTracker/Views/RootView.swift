//
//  RootView.swift
//  SubscriptionsTracker
//
//  Created by Nikita Shyshkin on 02/08/2025.
//

import SwiftData
import SwiftUI

struct RootView: View {
	private let notificationsService: NotificationsService
	private let modelContainer: ModelContainer
	private let subscriptionsViewModel: SubscriptionsViewModel
	
	init() {
		notificationsService = .init()
		
		do {
			modelContainer = try ModelContainer(for: Schema([Subscription.self]))
		} catch {
			fatalError(error.localizedDescription)
		}
		
		subscriptionsViewModel = SubscriptionsViewModel(
			modelContext: modelContainer.mainContext,
			notificationsService: notificationsService
		)
	}

	var body: some View {
		NavigationStack {
			SubscriptionsListView()
		}
		.preferredColorScheme(.dark)
		.modelContainer(modelContainer)
		.environment(subscriptionsViewModel)
		.task { await subscriptionsViewModel.requestNotificationsPermission() }
	}
}

#Preview {
	RootView()
}
