import Foundation

struct MovieResponse: Decodable {
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case movies = "Search"
    }
}

struct Movie: Codable, Comparable, Hashable, Identifiable, Equatable {
    
    var id: String
    var poster: String
    var title: String
    var yearOfRelease: Int

    // Conformance to Comparable
    static func < (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.yearOfRelease < rhs.yearOfRelease
    }

    // Coding keys
    enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case poster = "Poster"
        case title = "Title"
        case yearOfRelease = "Year"
    }

    // Custom initializer
    init(id: String, poster: String, title: String, yearOfRelease: Int) {
        self.poster = poster
        self.title = title
        self.yearOfRelease = yearOfRelease
        self.id = id
    }

    // Encodable initializer
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(poster, forKey: .poster)
        try container.encode(title, forKey: .title)
        try container.encode(yearOfRelease, forKey: .yearOfRelease)
    }

    // Decodable initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        poster = try container.decode(String.self, forKey: .poster)
        title = try container.decode(String.self, forKey: .title)
        let yearString = try container.decode(String.self, forKey: .yearOfRelease)
        yearOfRelease = Int(yearString) ?? 0
    }
}
