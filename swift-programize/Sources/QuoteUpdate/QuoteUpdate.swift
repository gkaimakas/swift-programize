//
//  QuoteUpdate.swift
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
public struct QuoteUpdate: Sendable {
    @ObservableState
    public struct State: Hashable, Sendable {
        var quoteUpdateStatus = WorkStatus()
        var original: QuoteDTO
        
        var text: String
        var author: String
        
        var focusedField: FocusedField?
        
        public init(_ original: QuoteDTO) {
            self.original = original
            self.text = original.text
            self.author = original.author ?? ""
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case task
        case tappedOnDismiss
        case tappedOnSave
        case quoteUpdateCompleted(Result<Void, any Error>)
        case tappedToDismissQuoteUpdateError
        case delegate(Delegate)
    }
    
    public enum Delegate {
        case quoteUpdated(QuoteDTO)
    }
    
    public enum FocusedField: Hashable, Sendable {
        case quote
        case author
    }
    
    @Dependency(\.quoteAPI.quoteUpdate) var quoteUpdate
    
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
            guard state.quoteUpdateStatus.isExecuting == false else { break }
            state.quoteUpdateStatus.start()
            
            let text = state.text
            let author = state.author.isEmpty ? nil : state.author
            
            return .run { [id = state.original.id] send in
                await send(.quoteUpdateCompleted(.init(catching: {
                    try await quoteUpdate(id, text, author)
                })))
            }
            
        case .quoteUpdateCompleted(.success):
            state.quoteUpdateStatus.success()
            let new = QuoteDTO(
                id: state.original.id,
                author: state.author.isEmpty ? nil : state.author,
                text: state.text
            )
            
            return .merge(
                .send(.delegate(.quoteUpdated(new))),
                .run(operation: { send in
                    @Dependency(\.dismiss) var dismiss
                    await dismiss()
                })
            )
            
        case let .quoteUpdateCompleted(.failure(err)):
            state.quoteUpdateStatus.failure(error: err)
            
        case .tappedToDismissQuoteUpdateError:
            state.quoteUpdateStatus.reset()
            
        case .delegate:
            break
        }
        
        return .none
    }
}
