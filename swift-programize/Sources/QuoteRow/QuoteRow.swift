//
//  QuoteRow.swift
//  swift-programize
//
//  Created by George Kaimakas on 18/10/24.
//

import APIs
import ComposableArchitecture
import Core
import DTOs
import Foundation
import QuoteUpdate

@Reducer
public struct QuoteRow: Sendable {
    @ObservableState
    public struct State: Hashable, Identifiable, Sendable {
        var quoteDeleteStatus = WorkStatus()
        public let id: QuoteDTO.ID
        var quote: QuoteDTO
        
        @Presents
        var destination: Destination.State?
        
        public init(_ quote: QuoteDTO) {
            self.id = quote.id
            self.quote = quote
        }
    }
    
    public enum Action {
        case swippedToUpdate
        case swippedToDelete
        case quoteDeleteCompleted(Result<Void, any Error>)
        
        case destination(PresentationAction<Destination.Action>)
        
        case delegate(Delegate)
    }
    
    public enum Delegate {
        case quoteDeleted
    }
    
    @Dependency(\.quoteAPI.quoteDelete) var quoteDelete
    
    public var body: some ReducerOf<Self> {
        Reduce(core)
            .ifLet(\.$destination, action: \.destination)
    }
    
    public init() {}
    
    func core(
        into state: inout State,
        action: Action
    ) -> Effect<Action> {
        switch action {
        case .swippedToDelete:
            guard state.quoteDeleteStatus.isExecuting == false else { break }
            state.quoteDeleteStatus.start()
            
            return .run { [id = state.id] send in
                await send(.quoteDeleteCompleted(.init(catching: {
                    try await quoteDelete(id)
                })))
            }
            
        case .quoteDeleteCompleted(.success):
            state.quoteDeleteStatus.success()
            return .send(.delegate(.quoteDeleted))
            
        case let .quoteDeleteCompleted(.failure(err)):
            state.quoteDeleteStatus.failure(error: err)
            
        case .swippedToUpdate:
            state.destination = .quoteUpdate(.init(state.quote))
            
        case let .destination(.presented(.quoteUpdate(.delegate(delegate)))):
            return quoteUpdateDelegate(&state, action: delegate)
            
        case .destination:
            break
            
        case .delegate:
            break
        }
        
        return .none
    }
    
    func quoteUpdateDelegate(
        _ state: inout State,
        action: QuoteUpdate.Delegate
    ) -> Effect<Action> {
        switch action {
        case let .quoteUpdated(newValue):
            state.quote = newValue
        }
        
        return .none
    }
}

extension QuoteRow {
    @Reducer(state: .hashable, .sendable)
    public enum Destination {
        case quoteUpdate(QuoteUpdate)
    }
}
