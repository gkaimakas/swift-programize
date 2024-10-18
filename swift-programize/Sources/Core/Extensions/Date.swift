//
//  File.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import Dependencies
import Foundation

public extension Date {
    func startOfDay() -> Date {
        @Dependency(\.calendar) var calendar
        return calendar.startOfDay(for: self)
    }
}
