//
//  QuoteUpdateView.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import ComposableArchitecture
import Core
import CoreUI
import Foundation
import SwiftUI

public struct QuoteUpdateView: View {
    @Bindable
    var store: StoreOf<QuoteUpdate>
    
    @FocusState
    var focusedField: QuoteUpdate.FocusedField?
    
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
        }
        .task { await store.send(.task).finish() }
        .bind($store.focusedField, to: $focusedField)
        .safeAreaInset(edge: .bottom) {
            switch store.quoteUpdateStatus {
            case .completed(.failure):
                Button {
                    store.send(.tappedToDismissQuoteUpdateError)
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
    
    public init(_ store: StoreOf<QuoteUpdate>) {
        self.store = store
    }
}
