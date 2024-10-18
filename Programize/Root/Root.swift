//
//  Root.swift
//  Programize
//
//  Created by George Kaimakas on 19/10/24.
//

import APIs
import ComposableArchitecture
import Foundation
import Network
import QuoteCreate
import QuoteList
import QuoteOfTheDay

@Reducer
struct Root {
    @ObservableState
    struct State: Hashable, Sendable {
        var quoteOfTheDay: QuoteOfTheDay.State
        var path = StackState<Path.State>()
        
        var hasInternetConnection: Bool = true
        
        @Presents
        var destination: Destination.State?
        
        init() {
            self.quoteOfTheDay = .init()
        }
    }
    
    enum Action {
        case task
        case networkStatusChanged(NWPath)
        
        case quoteOfTheDay(QuoteOfTheDay.Action)
        case path(StackAction<Path.State, Path.Action>)
        
        
        case tappedOnQuoteCreate
        case destination(PresentationAction<Destination.Action>)
    }
    
    @Dependency(\.networkMonitor) var networkMonitor
    
    var body: some ReducerOf<Self> {
        Scope(state: \.quoteOfTheDay, action: \.quoteOfTheDay) {
            QuoteOfTheDay()
        }
        
        Reduce(core)
            .forEach(\.path, action: \.path)
            .ifLet(\.$destination, action: \.destination)
    }
    
    init() {}
    
    func core(
        into state: inout State,
        action: Action
    ) -> Effect<Action> {
        
        switch action {
        case .task:
            return .run { send in
                networkMonitor.start()
                for await status in networkMonitor.path() {
                    await send(.networkStatusChanged(status))
                }
            }
            
        case let .networkStatusChanged(status):
            state.hasInternetConnection = status.status == .satisfied
            
        case let .quoteOfTheDay(.delegate(delegate)):
            return quoteOfTheDayDelegate(&state, action: delegate)
            
        case .quoteOfTheDay:
            break
            
        case .path:
            break
            
        case .tappedOnQuoteCreate:
            state.destination = .quoteCreate(.init())
            
        case .destination:
            break
        }
        
        return .none
    }
    
    func quoteOfTheDayDelegate(
        _ state: inout State,
        action: QuoteOfTheDay.Delegate
    ) -> Effect<Action> {
        switch action {
        case .tappedOnQuoteList:
            state.path.append(.quoteList(.init()))
        }
        
        return .none
    }
}

extension Root {
    @Reducer(state: .hashable, .sendable)
    enum Path {
        case quoteList(QuoteList)
    }
    
    @Reducer(state: .hashable, .sendable)
    enum Destination {
        case quoteCreate(QuoteCreate)
    }
}
