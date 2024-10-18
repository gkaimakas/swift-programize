//
//  NetworkMonitor.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import Dependencies
import Foundation
import Network

public struct NetworkMonitor: Sendable {
    
    public var start: @Sendable () -> Void
    public var cancel: @Sendable () -> Void
    
    public var path: @Sendable (
    ) -> AsyncStream<NWPath>
    
    public init(
        start: @escaping @Sendable (
        ) -> Void,
        
        cancel: @escaping @Sendable (
        ) -> Void,
        
        path: @escaping @Sendable (
        ) -> AsyncStream<NWPath>
    ) {
        self.start = start
        self.cancel = cancel
        self.path = path
    }
}

extension NetworkMonitor: DependencyKey {
    public static var liveValue: NetworkMonitor {
        let stream = Stream<NWPath>()
        
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            stream.send(event: path)
        }
        
        let res = NetworkMonitor(
            start: {
                let queue = DispatchQueue(label: "NetworkMonitor")
                monitor.start(queue: queue)
            },
            cancel: { monitor.cancel() },
            path: { stream.events }
        )
        
        return res
    }
}
