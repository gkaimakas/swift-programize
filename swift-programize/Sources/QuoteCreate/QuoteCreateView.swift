//
//  QuoteCreateView.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import ComposableArchitecture
import Core
import CoreUI
import Foundation
import SwiftUI

public struct QuoteCreateView: View {
    @Bindable
    var store: StoreOf<QuoteCreate>
    
    @FocusState
    var focusedField: QuoteCreate.FocusedField?
    
    public var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("quote", text: $store.text, axis: .vertical)
                        .focused($focusedField, equals: .quote)
                } header: {
                    Text("quote")
                }
                
                Section {
                    TextField("author", text: $store.author)
                        .focused($focusedField, equals: .author)
                } header: {
                    Text("author")
                }
            }
            .navigationTitle("new quote")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        store.send(.tappedOnDismiss)
                    } label: {
                        Label("close", systemImage: "xmark.circle.fill")
                            .labelStyle(.iconOnly)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        store.send(.tappedOnSave)
                    } label: {
                        Label("save", systemImage: "checkmark")
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                switch store.quoteCreateStatus {
                case .completed(.failure):
                    Button {
                        store.send(.tappedToDismissQuoteCreateError)
                    } label: {
                        ErrorView()
                    }
                    .buttonStyle(.plain)
                    .padding()
                    
                case _:
                    EmptyView()
                }
            }
        }
        .task { await store.send(.task).finish() }
        .bind($store.focusedField, to: $focusedField)
    }
    
    public init(_ store: StoreOf<QuoteCreate>) {
        self.store = store
    }
}
