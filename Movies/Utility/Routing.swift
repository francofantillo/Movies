//
//  Routing.swift
//  Movies
//
//  Created by Franco Fantillo on 2025-02-25.
//

import SwiftUI

enum Route: Hashable {
    
    case movieList
    case movieDetails(Movie)

}

struct Router: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .movieDetails(let movie):
                   MovieDetails(movie: movie)
                case .movieList:
                    EmptyView()
                }
            }
    }
}

extension View {
    func router() -> some View {
        modifier(Router())
    }
}
