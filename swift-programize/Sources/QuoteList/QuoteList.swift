//
//  QuoteList.swift
//  swift-programize
//
//  Created by George Kaimakas on 18/10/24.
//

import APIs
import ComposableArchitecture
import Core
import DTOs
import Foundation
import QuoteRow

@Reducer
public struct QuoteList: Sendable {
    @ObservableState
    public struct State: Hashable, Sendable {
        var quotesStatus = WorkStatus()
        var quoteRows: IdentifiedArrayOf<QuoteRow.State>
        
        public init() {
            self.quoteRows = .init()
        }
    }
    
    public enum Action {
        case task
        case fetchQuotesCompleted(Result<[QuoteDTO], any Error>)
        case tappedToDismissQuotesError
        case quoteRow(IdentifiedActionOf<QuoteRow>)
    }
    
    public enum CancellationID: Hashable, Sendable {
        case crudEvents
    }
    
    @Dependency(\.quoteCRUDEventStream) var quoteCRUDEventStream
    @Dependency(\.quoteAPI.quotes) var quotes
    
    public var body: some ReducerOf<Self> {
        Reduce(core)
            .forEach(\.quoteRows, action: \.quoteRow) {
                QuoteRow()
            }
    }
    
    public init() {}
    
    func core(
        into state: inout State,
        action: Action
    ) -> Effect<Action> {
        switch action {
        case .task:
            var effects: [Effect<Action>] = []
            
            if state.quotesStatus.isExecuting == false {
                state.quotesStatus.start()
                
                effects.append(.run { send in
                    let res = await Result(catching: { try await quotes() })
                    await send(.fetchQuotesCompleted(res))
                })
            }
            
            effects.append(
                .run { send in
                    for await _ in quoteCRUDEventStream.events {
                        let res = await Result(catching: { try await quotes() })
                        await send(.fetchQuotesCompleted(res))
                    }
                }
            )
            
            return .concatenate(effects)
            
        case let .fetchQuotesCompleted(.success(response)):
            state.quotesStatus.success()
            state.quoteRows = IdentifiedArray(uniqueElements: response.map(QuoteRow.State.init))
            
        case let .fetchQuotesCompleted(.failure(err)):
            state.quotesStatus.failure(error: err)
            
        case .tappedToDismissQuotesError:
            state.quotesStatus.reset()
            
        case let .quoteRow(.element(id, action: .delegate(delegate))):
            return quoteRowDelegate(&state, id: id, action: delegate)
            
        case .quoteRow:
            break
        }
        return .none
    }
    
    func quoteRowDelegate(
        _ state: inout State,
        id: QuoteRow.State.ID,
        action: QuoteRow.Delegate
    ) -> Effect<Action> {
        switch action {
        case .quoteDeleted:
            state.quoteRows.remove(id: id)
        }
        return .none
    }
}
