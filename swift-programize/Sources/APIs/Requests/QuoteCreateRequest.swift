//
//  QuoteCreateRequest.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import Foundation

struct QuoteCreateRequest: Codable, Sendable {
    let text: String
    let author: String?
}
