import Foundation
import SwiftUI

@MainActor
class MovieViewModel: ObservableObject {
    
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var searchString: String = ""
    @Published var images: [String: UIImage] = [:]
    @Published var currentPage: Int = 1
    
    private var errorHandling: ErrorHandling
    let dataService: DataService

    init(errorHandling: ErrorHandling, dataService: DataService = DataService(client: HttpClient(session: URLSession.shared))) {
        self.dataService = dataService
        self.errorHandling = errorHandling
    }

    var searchStringBinding: Binding<String> {
        Binding(
            get: { self.searchString },
            set: { newValue in
                guard self.searchString != newValue else { return }
                self.searchString = newValue
                self.currentPage = 1
                self.movies = []

                Task {
                    await self.setMovies(searchString:newValue)
                }
            }
        )
    }

    func searchMovies(searchString: String) async -> [Movie] {
        guard !searchString.isEmpty else { return [] }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let fetchedMovies: MovieResponse = try await dataService.search(searchString: searchString, page: currentPage)
            await loadImages(for: fetchedMovies.movies)
            return fetchedMovies.movies
            
        } catch let apiError as APIErrors {
            errorHandling.handleAPIErrorWithToast(error: apiError)
        } catch {
            errorHandling.handleErrorWithToast(error: error)
        }
        return []
    }

    func appendMovies() async {
        
        let newMovies = await searchMovies(searchString: searchString)
        movies.append(contentsOf: newMovies)
        currentPage += 1
    }
    
    private func setMovies(searchString: String) async {
        
        let newMovies = await searchMovies(searchString: searchString)
        movies = newMovies
        currentPage += 1
    }

    private func loadImages(for movies: [Movie]) async {
        for movie in movies {
            guard let url = URL(string: movie.poster) else { continue }
            do {
                let data = try await dataService.getImageData(url: url)
                if let uiImage = UIImage(data: data) {
                    images[movie.poster] = uiImage
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func image(for movie: Movie) -> UIImage? {
        return images[movie.poster]
    }
}
