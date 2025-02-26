import SwiftUI

struct MovieListView: View {
    
    @ObservedObject var viewModel: MovieViewModel
    @EnvironmentObject var errorHandling: ErrorHandling

    var body: some View {
        NavigationView {
            ZStack {
                
                if viewModel.isLoading {
                    LoadingView()
                }
                
                VStack {
                    SearchBar(searchString: viewModel.searchStringBinding)
                    MovieList(viewModel: viewModel)
                }
            }
            .navigationTitle("Movies")
        }
        .withErrorHandling()
        
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(viewModel: MovieViewModel(errorHandling: ErrorHandling()))
            .environmentObject(ErrorHandling())
    }
}
