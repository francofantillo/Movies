import SwiftUI

struct MovieDetailsView: View {
    let movie: Movie

    var body: some View {
        VStack {
            Text(movie.title)
                .font(.largeTitle)
            Text("Year: \(movie.yearOfRelease)")
                .font(.title)
            // Add more movie details here
        }
        .padding()
    }
}
