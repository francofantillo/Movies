import SwiftUI

struct MovieListView: View {
    
    @ObservedObject var viewModel: MovieViewModel

    var body: some View {
        NavigationView {
            ZStack {
                
                VStack {
                    SearchBar(searchString: viewModel.searchStringBinding)
                    MovieList(viewModel: viewModel)
                }
                
                LoadingView(isLoading: $viewModel.isLoading)
                
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
