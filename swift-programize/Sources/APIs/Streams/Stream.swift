//
//  Stream.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import ComposableArchitecture
import Foundation

public final class Stream<Value: Sendable>: @unchecked Sendable {
    public struct ContinuationID: Sendable, Identifiable {
        public let id: UUID
        let continuation: AsyncStream<Value>.Continuation
        
        init(
            id: UUID = .init(),
            continuation: AsyncStream<Value>.Continuation
        ) {
            self.id = id
            self.continuation = continuation
        }
    }
    
    private let lock = NSLock()
    private var registrar: IdentifiedArrayOf<ContinuationID> = .init()
    
    public var events: AsyncStream<Value> {
        let (stream, continuation) = AsyncStream<Value>.makeStream()
        
        let token = register(continuation)
        continuation.onTermination = { [weak self] _ in
            self?.unregister(token: token)
        }
        
        return stream
    }
    
    public init() {}
    
    func send(event: Value) {
        lock.lock()
        for token in registrar {
            token.continuation.yield(event)
        }
        lock.unlock()
    }
    
    func finish() {
        lock.lock()
        for token in registrar {
            token.continuation.finish()
        }
        lock.unlock()
    }
    
    func register(_ continuation: AsyncStream<Value>.Continuation) -> ContinuationID {
        let token = ContinuationID(continuation: continuation)

        lock.lock()
        registrar.append(token)
        lock.unlock()
        
        return token
    }
    
    func unregister(token: ContinuationID) {
        lock.lock()
        registrar.remove(id: token.id)
        lock.unlock()
    }
}

