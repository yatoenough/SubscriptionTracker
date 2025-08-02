//
//  RootView.swift
//  SubscriptionsTracker
//
//  Created by Nikita Shyshkin on 02/08/2025.
//

import SwiftUI

struct RootView: View {
    var body: some View {
		NavigationStack {
			SubscriptionsListView()
		}
    }
}

#Preview {
    RootView()
}
