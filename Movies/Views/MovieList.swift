import SwiftUI

enum UIConfig: CGFloat {
    case thumbnailWidth = 50
    case thumbnailHeight = 75
    case cornerRadius = 8
    case filmSize = 100
}

struct MovieList: View {
    
    @ObservedObject var viewModel: MovieViewModel

    var body: some View {
        if viewModel.movies.isEmpty {
            VStack {
                Image(systemName: "film")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIConfig.filmSize.rawValue, height: UIConfig.filmSize.rawValue)
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
                            .frame(width: UIConfig.thumbnailWidth.rawValue, height: UIConfig.thumbnailHeight.rawValue)
                            .cornerRadius(UIConfig.cornerRadius.rawValue)
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIConfig.thumbnailWidth.rawValue, height: UIConfig.thumbnailHeight.rawValue)
                            .cornerRadius(UIConfig.cornerRadius.rawValue)
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
