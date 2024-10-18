//
//  NavigationLinkButtonStyle.swift
//  swift-programize
//
//  Created by George Kaimakas on 19/10/24.
//

import Foundation
import SwiftUI

public struct NavigationLinkButtonStyle: PrimitiveButtonStyle {
    let verticalAlignment: VerticalAlignment
    let padding: EdgeInsets
    
    public init(
        _ verticalAlignment: VerticalAlignment,
        padding: EdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    ) {
        self.verticalAlignment = verticalAlignment
        self.padding = padding
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.trigger()
        } label: {
            HStack(alignment: verticalAlignment) {
                configuration.label
                
                Spacer()
                
                Image.chevronRight
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .frame(width: 6)
            }
            .padding(padding)
            .contentShape(Rectangle())
        }
        .buttonStyle(.bordered)
    }
}

public extension PrimitiveButtonStyle where Self == NavigationLinkButtonStyle {
    static var navigationLink: Self { .init(.center, padding: .init(top: 0, leading: 0, bottom: 0, trailing: 0)) }
    
    static func navigationLink(alignment: VerticalAlignment) -> Self {
        .init(alignment)
    }
}
