//
//  QuoteListView.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import ComposableArchitecture
import CoreUI
import Foundation
import QuoteRow
import SwiftUI

public struct QuoteListView: View {
    var store: StoreOf<QuoteList>
    
    public var body: some View {
        List {
            ForEach(store.scope(state: \.quoteRows, action: \.quoteRow)) { store in
                QuoteRowView(store)
            }
        }
        .task { await store.send(.task).finish() }
        .safeAreaInset(edge: .bottom) {
            switch store.quotesStatus {
            case .completed(.failure):
                Button {
                    store.send(.tappedToDismissQuotesError)
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
    
    public init(_ store: StoreOf<QuoteList>) {
        self.store = store
    }
}
