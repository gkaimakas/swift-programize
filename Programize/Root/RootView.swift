//
//  RootView.swift
//  Programize
//
//  Created by George Kaimakas on 19/10/24.
//

import ComposableArchitecture
import Core
import CoreUI
import Foundation
import QuoteCreate
import QuoteList
import QuoteOfTheDay
import SwiftUI

struct RootView: View {
    @Bindable
    var store: StoreOf<Root>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            rootView()
        } destination: { store in
            destinationView(store)
        }
        .sheet(item: $store.scope(state: \.destination, action: \.destination)) { store in
            switch store.case {
            case let .quoteCreate(store):
                QuoteCreateView(store)
            }
        }
        .safeAreaInset(edge: .bottom) {
            if store.hasInternetConnection == false {
                ErrorView(message: "No internet connection")
                    .padding()
            }
        }
    }
    
    init(_ store: StoreOf<Root>) {
        self.store = store
    }
    
    @ViewBuilder
    func rootView() -> some View {
        QuoteOfTheDayView(store.scope(state: \.quoteOfTheDay, action: \.quoteOfTheDay))
    }
    
    @ViewBuilder
    func destinationView(_ store: StoreOf<Root.Path>) -> some View {
        switch store.case {
        case let .quoteList(store):
            QuoteListView(store)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Quotes")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            self.store.send(.tappedOnQuoteCreate)
                        } label: {
                            Label("new quote", systemImage: "plus")
                        }
                    }
                }
        }
    }
}
