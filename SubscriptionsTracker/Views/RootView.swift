//
//  RootView.swift
//  SubscriptionsTracker
//
//  Created by Nikita Shyshkin on 02/08/2025.
//

import SwiftData
import SwiftUI

struct RootView: View {
	let modelContainer: ModelContainer = {
		do {
			let schema = Schema([Subscription.self])
			return try ModelContainer(for: schema)
		} catch {
			fatalError(error.localizedDescription)
		}
	}()
	
	let notificationsService = NotificationsService()

	var body: some View {
		NavigationStack {
			SubscriptionsListView()
				.modelContainer(modelContainer)
				.environment(
					SubscriptionsViewModel(
						modelContext: modelContainer.mainContext,
						notificationsService: notificationsService
					)
				)
				.task {
					let granted = await notificationsService.requestAuthorization(options: [.alert, .sound, .badge])
					
					if !granted {
						print("Notifications permission not granted")
					}
				}
		}
	}
}

#Preview {
	RootView()
}
