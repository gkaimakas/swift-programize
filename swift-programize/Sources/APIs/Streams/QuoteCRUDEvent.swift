//
//  QuoteCRUDEvent.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import Dependencies
import Foundation

public enum QuoteCRUDEvent: Sendable {
    case quoteCreated
}

struct QuoteCRUDEventKey: DependencyKey {
    static var liveValue: Stream<QuoteCRUDEvent> {
        .init()
    }
}
