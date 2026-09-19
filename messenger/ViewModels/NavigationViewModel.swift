//
//  Navigation.swift
//  messenger
//
//  Created by Hemanth Kumar Reddy on 19/09/26.
//

import Foundation
import SwiftUI

enum Route: Hashable {
    case chat
    case detail(Conversation)
}

@Observable
class NavigationViewModel {
    var path: [Route] = []

    func navigate(to route: Route) {
        path.append(route)
    }

    @ViewBuilder
    func destinationView(for route: Route) -> some View {
        switch route {
        case .detail(let item):
            ConversationDetailView(conversation: item)
        case .chat:
            ConversationView()
        }
    }
}
