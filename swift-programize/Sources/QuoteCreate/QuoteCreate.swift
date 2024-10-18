//
//  QuoteCreate.swift
//  swift-programize
//
//  Created by George Kaimakas on 18/10/24.
//

import APIs
import ComposableArchitecture
import Core
import DTOs
import Foundation

@Reducer
public struct QuoteCreate: Sendable {
    @ObservableState
    public struct State: Hashable, Sendable {
        var quoteCreateStatus = WorkStatus()
        var text: String
        var author: String
        
        var focusedField: FocusedField?
        
        public init() {
            self.text = ""
            self.author = ""
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case task
        case tappedOnDismiss
        case tappedOnSave
        case quoteCreateCompleted(Result<Void, any Error>)
        case tappedToDismissQuoteCreateError
        case delegate(Delegate)
    }
    
    public enum Delegate {
        case quoteCreated
    }
    
    public enum FocusedField: Hashable, Sendable {
        case quote
        case author
    }
    
    @Dependency(\.quoteAPI.quoteCreate) var quoteCreate
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce(core)
    }
    
    public init() {}
    
    func core(
        into state: inout State,
        action: Action
    ) -> Effect<Action> {
        switch action {
        case .binding:
            break
            
        case .task:
            state.focusedField = .quote
            
        case .tappedOnDismiss:
            return .run { send in
                @Dependency(\.dismiss) var dismiss
                await dismiss()
            }
            
        case .tappedOnSave:
            guard state.quoteCreateStatus.isExecuting == false else { break }
            state.quoteCreateStatus.start()
            
            let text = state.text
            let author = state.author.isEmpty ? nil : state.author
            
            return .run { send in
                await send(.quoteCreateCompleted(.init(catching: {
                    try await quoteCreate(text, author)
                })))
            }
            
        case .quoteCreateCompleted(.success):
            state.quoteCreateStatus.success()
            
            return .merge(
                .send(.delegate(.quoteCreated)),
                .run(operation: { send in
                    @Dependency(\.dismiss) var dismiss
                    await dismiss()
                })
            )
            
        case let .quoteCreateCompleted(.failure(err)):
            state.quoteCreateStatus.failure(error: err)
            
        case .tappedToDismissQuoteCreateError:
            state.quoteCreateStatus.reset()
            
        case .delegate:
            break
        }
        
        return .none
    }
}
