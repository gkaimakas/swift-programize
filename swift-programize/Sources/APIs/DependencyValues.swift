//
//  DependencyValues.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import Alamofire
import Dependencies
import Foundation

public extension DependencyValues {
    var quoteAPI: QuoteAPI {
        get { self[QuoteAPI.self] }
        set { self[QuoteAPI.self] = newValue }
    }
    
    var networkMonitor: NetworkMonitor {
        get { self[NetworkMonitor.self] }
        set { self[NetworkMonitor.self] = newValue }
    }
    
    var quoteCRUDEventStream: Stream<QuoteCRUDEvent> {
        get { self[QuoteCRUDEventKey.self] }
        set { self[QuoteCRUDEventKey.self] = newValue }
    }
}

extension DependencyValues {
    var session: Session {
        get { self[Session.self] }
        set { self[Session.self] = newValue }
    }
    
    var sdManager: SDManager {
        get { self[SDManager.self] }
        set { self[SDManager.self] = newValue }
    }
    
}
