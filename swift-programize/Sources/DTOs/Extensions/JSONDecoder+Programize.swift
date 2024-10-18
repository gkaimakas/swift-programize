//
//  JSONDecoder+Programize.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import Foundation

public extension JSONDecoder {
    static let programize: JSONDecoder = {
        var res = JSONDecoder()
        res.dateDecodingStrategy = .iso8601
        return res
    }()
}
