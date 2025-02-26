import SwiftUI

struct MovieList: View {
    
    @ObservedObject var viewModel: MovieViewModel

    var body: some View {
        if viewModel.movies.isEmpty {
            VStack {
                Image(systemName: "film")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                Text("No movies found")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            .padding()
        } else {
            List(viewModel.movies) { movie in
                HStack {
                    if let image = viewModel.image(for: movie) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 75)
                            .cornerRadius(8)
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 75)
                            .cornerRadius(8)
                    }
                    VStack(alignment: .leading) {
                        Text(movie.title)
                            .font(.headline)
                        Text("\(movie.yearOfRelease)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}
