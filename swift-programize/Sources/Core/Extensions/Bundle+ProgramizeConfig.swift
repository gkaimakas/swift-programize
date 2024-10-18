//
//  File.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import Foundation

public struct ProgramizeConfig: Hashable, Sendable {
    public let baseURL: URL
    init(_ dict: [String: Any]) {
        guard let baseURLRaw = dict["BaseURL"] as? String else {
            fatalError("BaseURL not found in Programize")
        }
        
        self.baseURL = URL(string: "http://\(baseURLRaw)")!
    }
}

public extension Bundle {
    var programizeConfig: ProgramizeConfig {
        guard let configDict = infoDictionary?["Programize"] as? [String: Any] else {
            fatalError("Programize dict not found in info.plist")
        }
        
        return .init(configDict)
    }
}
