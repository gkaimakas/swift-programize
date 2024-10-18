//
//  QuoteOfTheDayView.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import ComposableArchitecture
import CoreUI
import Foundation
import SwiftUI

public struct QuoteOfTheDayView: View {
    var store: StoreOf<QuoteOfTheDay>
    
    public var body: some View {
        
        Group {
            if store.quote == nil {
                VStack {
                    allQuotesView()
                }
                .frame(maxHeight: .infinity)
                .padding()
            } else {
                ViewThatFits {
                    ScrollView {
                        quoteOfTheDayView()
                            .padding()
                    }
                    
                    quoteOfTheDayView()
                        .padding()
                    
                }
            }
        }
        .task { await store.send(.task).finish() }
        .safeAreaInset(edge: .bottom) {
            switch store.quoteOfTheDayStatus {
            case .completed(.failure):
                Button {
                    store.send(.tappedToDismissQuoteOfTheDayError)
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
    
    public init(_ store: StoreOf<QuoteOfTheDay>) {
        self.store = store
    }
    
    @ViewBuilder
    func quoteOfTheDayView() -> some View {
        VStack(alignment: .leading, spacing: 24) {
            if let quote = store.quote {
                VStack(alignment: .leading, spacing: 8) {
                    (
                        Text(Image.quoteOpening)
                            .font(.caption2)
                        + Text(quote.text)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        + Text(Image.quoteClosing)
                            .font(.caption2)
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let author = quote.author {
                        Text(author)
                            .font(.body)
                    }
                }
            }
            allQuotesView()
        }
        .padding()
    }
    
    @ViewBuilder
    func allQuotesView() -> some View {
        Button {
            store.send(.tappedOnQuoteList)
        } label: {
            Text("all quotes")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.navigationLink)
    }
}
