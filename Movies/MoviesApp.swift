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
    
    init() {
        
        let errorhandling = ErrorHandling()
        _errorHandling = StateObject(wrappedValue: errorhandling)
        _movieViewModel = StateObject(wrappedValue: MovieViewModel(errorHandling: errorhandling))
    }
    
    var body: some Scene {
        WindowGroup {
            MovieListView(viewModel: movieViewModel)
                .environmentObject(errorHandling)
        }
    }
}
