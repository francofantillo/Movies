import SwiftUI

enum UIConfig: CGFloat {
    case cornerRadius = 8
    case filmSize = 100
    case buttonPadding = 6
    case thumbnailHeight = 275
}

struct MovieList: View {
    
    @ObservedObject var viewModel: MovieViewModel

    var body: some View {
        if viewModel.movies.isEmpty {
            EmptyStateView()
        } else {
            List {
                ForEach(viewModel.movies) { movie in
                    MovieRow(movie: movie, image: viewModel.image(for: movie))
                        .onAppear(){
                            if (viewModel.movies.last == movie){
                                
                                Task { await viewModel.appendMovies() }
                            }
                        }
                }
            }
            .listRowSpacing(16.0)
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "film")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIConfig.filmSize.rawValue, height: UIConfig.filmSize.rawValue)
                .foregroundColor(.gray)
            Text("No movies found")
                .font(.headline)
                .foregroundColor(.gray)
            Spacer()
        }
        .padding()
    }
}

struct MovieRow: View {
    let movie: Movie
    let image: UIImage?

    var body: some View {
        VStack {
            MovieImageView(image: image)
            MovieDetails(movie: movie)
            Spacer()
            DetailsButton()
        }
    }
}

struct MovieImageView: View {
    let image: UIImage?

    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: UIConfig.cornerRadius.rawValue))
                    .frame(width: geometry.size.width, height: geometry.size.height)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: UIConfig.cornerRadius.rawValue))
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .frame(height: UIConfig.thumbnailHeight.rawValue)
        .padding([.bottom, .top], 20)
        .shadow(radius: 15)
    }
}

struct MovieDetails: View {
    let movie: Movie

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(alignment: .firstTextBaseline) {
                    Text("Title:")
                        .font(.headline)
                    Text(movie.title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                HStack(alignment: .firstTextBaseline) {
                    Text("Year:")
                        .font(.headline)
                    Text(String(movie.yearOfRelease))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
    }
}

struct DetailsButton: View {
    var body: some View {
        Button(action: {
            // Button action here
        }) {
            HStack {
                Text("Details")
                    .padding(UIConfig.buttonPadding.rawValue)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }
            .background(.black)
            .cornerRadius(UIConfig.cornerRadius.rawValue)
        }
        .padding(.bottom, 16)
    }
}

struct MovieList_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MovieViewModel(errorHandling: ErrorHandling())
        viewModel.movies = [
            Movie(id: "122", poster: "", title: "Inception of the craziest ideas known to man over and over again.", yearOfRelease: 2010),
            Movie(id: "123", poster: "", title: "The Dark Knight", yearOfRelease: 2008),
            Movie(id: "124", poster: "", title: "Inception", yearOfRelease: 2010)
        ]
        return MovieList(viewModel: viewModel)
    }
}
