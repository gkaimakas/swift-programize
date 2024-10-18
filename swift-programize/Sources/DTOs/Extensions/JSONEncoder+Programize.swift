//
//  JSONEncoder+Programize.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import Foundation

public extension JSONEncoder {
    static let programize: JSONEncoder = {
        var res = JSONEncoder()
        res.dateEncodingStrategy = .iso8601
        return res
    }()
}
