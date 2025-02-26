//
//  MoviesApp.swift
//  Movies
//
//  Created by Franco Fantillo on 2025-02-25.
//

import SwiftUI

@main
struct MoviesApp: App {
    
    @StateObject private var errorHandling = ErrorHandling()
    @StateObject private var movieViewModel: MovieViewModel
    @StateObject private var navPath = NavigationObject()
    
    init() {
        let errorhandling = ErrorHandling()
        _errorHandling = StateObject(wrappedValue: errorhandling)
        _movieViewModel = StateObject(wrappedValue: MovieViewModel(errorHandling: errorhandling))
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navPath.path) {
                MovieListView(viewModel: movieViewModel)
                    .router()
                    .environmentObject(errorHandling)
                    .environmentObject(navPath)
            }
        }
    }
}
