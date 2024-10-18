//
//  ErrorView.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import Foundation
import SwiftUI

public struct ErrorView: View {
    let message: LocalizedStringKey
    
    public var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Image.exclamationmarkCircle
            
            Text(message)
        }
        .font(.caption)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(.regularMaterial)
                .stroke(.secondary, lineWidth: 0.5)
        }
    }
    
    public init(message: LocalizedStringKey = "something went wrong...") {
        self.message = message
    }
}
