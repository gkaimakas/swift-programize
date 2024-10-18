//
//  QuoteOfTheDay.swift
//  swift-programize
//
//  Created by George Kaimakas on 18/10/24.
//

import APIs
import ComposableArchitecture
import ConcurrencyExtras
import Core
import DTOs
import Foundation

@Reducer
public struct QuoteOfTheDay: Sendable {
    @ObservableState
    public struct State: Hashable, Sendable {
        var quoteOfTheDayStatus = WorkStatus()
        
        var quote: QuoteDTO?
        
        public init() {}
    }
    
    public enum Action {
        case task
        case fetchQuoteOfTheDayCompleted(Result<QuoteDTO?, any Error>)
        case tappedOnQuoteList
        case tappedToDismissQuoteOfTheDayError
        case delegate(Delegate)
    }
    
    public enum Delegate {
        case tappedOnQuoteList
    }
    
    @Dependency(\.date) var date
    @Dependency(\.quoteAPI.quoteOfTheDay) var quoteOfTheDay
    
    public var body: some ReducerOf<Self> {
        Reduce(core)
    }
    
    public init() {}
    
    func core(
        into state: inout State,
        action: Action
    ) -> Effect<Action> {
        
        switch action {
        case .task:
            guard state.quoteOfTheDayStatus.isExecuting == false else { break }
            state.quoteOfTheDayStatus.start()
            
            let now = date()
            
            return .run { send in
                await send(.fetchQuoteOfTheDayCompleted(.init(action: {
                    try await quoteOfTheDay(now)
                })))
            }
            
        case let .fetchQuoteOfTheDayCompleted(.success(response)):
            state.quoteOfTheDayStatus.success()
            state.quote = response
            
        case let .fetchQuoteOfTheDayCompleted(.failure(err)):
            state.quoteOfTheDayStatus.failure(error: err)
            
        case .tappedOnQuoteList:
            return .send(.delegate(.tappedOnQuoteList))
            
        case .tappedToDismissQuoteOfTheDayError:
            state.quoteOfTheDayStatus.start()
            
            let now = date()
            
            return .run { send in
                await send(.fetchQuoteOfTheDayCompleted(.init(action: {
                    try await quoteOfTheDay(now)
                })))
            }
            
        case .delegate:
            break
        }
        
        return .none
    }
}
