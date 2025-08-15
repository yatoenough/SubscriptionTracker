//
//  PreviewDataModifier.swift
//  SubscriptionsTracker
//
//  Created by Nikita Shyshkin on 02/08/2025.
//

import SwiftData
import SwiftUI

struct PreviewDataModifier: PreviewModifier {
    struct Context {
        let modelContainer: ModelContainer
        let subscriptionsViewModel: SubscriptionsViewModel
    }

    static func makeSharedContext() -> Context {
        do {
            let container = try ModelContainer(
                for: Subscription.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
			container.mainContext.insert(Subscription.example)
            let viewModel = SubscriptionsViewModel(modelContext: container.mainContext, notificationsService: NotificationsService())
            return Context(modelContainer: container, subscriptionsViewModel: viewModel)
        } catch {
            fatalError("Failed to create ModelContainer for previews: \(error.localizedDescription)")
        }
    }

    func body(content: Content, context: Context) -> some View {
        content
            .environment(context.subscriptionsViewModel)
            .modelContainer(context.modelContainer)
    }
}
