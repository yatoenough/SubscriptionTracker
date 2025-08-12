//
//  RootView.swift
//  SubscriptionsTracker
//
//  Created by Nikita Shyshkin on 02/08/2025.
//

import SwiftData
import SwiftUI

struct RootView: View {
	private let modelContainer: ModelContainer = {
		do {
			let schema = Schema([Subscription.self])
			return try ModelContainer(for: schema)
		} catch {
			fatalError(error.localizedDescription)
		}
	}()
	
	private let notificationsService = NotificationsService()
	
	@State private var isNotificationsPermissionDenied = false

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
						isNotificationsPermissionDenied = true
					}
				}
				.alert("Notifications permission denied", isPresented: $isNotificationsPermissionDenied) {
					Button("OK") {}
				} message: {
					Text("Notifications permission was not granted. You will not be notified about subscription due dates. You can enable it in Settings > Notifications > SubTrack")
				}
		}
	}
}

#Preview {
	RootView()
}
