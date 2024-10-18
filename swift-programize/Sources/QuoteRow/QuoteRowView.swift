//
//  QuoteRowView.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import ComposableArchitecture
import DTOs
import Foundation
import QuoteUpdate
import SwiftUI

public struct QuoteRowView: View {
    @Bindable
    var store: StoreOf<QuoteRow>
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(store.quote.text)
            
            if let author = store.quote.author {
                Text(author)
                    .font(.caption2)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button {
                store.send(.swippedToUpdate)
            } label: {
                Text("update")
            }
            .tint(.accentColor)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                store.send(.swippedToDelete)
            } label: {
                Text("delete")
            }
            .tint(.red)
        }
        .sheet(item: $store.scope(state: \.destination, action: \.destination)) { store in
            switch store.case {
            case let .quoteUpdate(store):
                QuoteUpdateView(store)
            }
        }
    }
    
    public init(_ store: StoreOf<QuoteRow>) {
        self.store = store
    }
}
