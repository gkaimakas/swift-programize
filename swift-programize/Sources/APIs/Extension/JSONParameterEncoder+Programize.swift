//
//  JSONParameterEncoder+Programize.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import Alamofire
import DTOs
import Foundation

extension JSONParameterEncoder {
    static let programize: JSONParameterEncoder = {
        let encoder = JSONEncoder.programize
        return .init(encoder: encoder)
    }()
}
