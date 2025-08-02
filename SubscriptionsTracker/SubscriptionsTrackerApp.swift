//
//  SubscriptionsTrackerApp.swift
//  SubscriptionsTracker
//
//  Created by Nikita Shyshkin on 02/08/2025.
//

import SwiftData
import SwiftUI

@main
struct SubscriptionsTrackerApp: App {
	let modelContainer: ModelContainer = {
		do {
			let schema = Schema([Subscription.self])
			return try ModelContainer(for: schema)
		} catch {
			fatalError(error.localizedDescription)
		}
	}()

	var body: some Scene {
		WindowGroup {
			RootView()
				.modelContainer(modelContainer)
		}
	}
}
