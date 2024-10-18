//
//  API.swift
//  swift-programize
//
//  Created by George Kaimakas on 21/10/24.
//

import Alamofire
import Dependencies
import Foundation

extension Session: @retroactive DependencyKey {
    public static var liveValue: Session {
        Session()
    }
    
    public static var testValue: Session {
        Session()
    }
}
