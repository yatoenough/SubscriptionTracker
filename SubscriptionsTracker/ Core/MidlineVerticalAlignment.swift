//
//  MidlineVerticalAlignment.swift
//  SubscriptionsTracker
//
//  Created by Nikita Shyshkin on 12/08/2025.
//

import SwiftUI

extension VerticalAlignment {
	enum Midline: AlignmentID {
		static func defaultValue(in context: ViewDimensions) -> CGFloat {
			context[.top]
		}
	}
	
	static let midline = VerticalAlignment(Midline.self)
}
