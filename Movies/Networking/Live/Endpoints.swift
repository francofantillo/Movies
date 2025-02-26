
import Foundation


enum Endpoint: String {
    case search = "/search"
}


enum APIConfig {
    case production
    case staging
    case development
    case local
    case custom(scheme: String, host: String)

    var scheme: String {
        switch self {
        case .custom(let scheme, _):
            return scheme
        default:
            return "http"
        }
    }

    var host: String {
        switch self {
        case .production, .staging, .development, .local:
            return "www.omdbapi.com"
        case .custom(_, let host):
            return host
        }
    }
}

enum APIEndpoint {
    
    case search(apiKey: String, searchString: String)

    func url(with config: APIConfig) -> URL? {
        var components = URLComponents()
        components.scheme = config.scheme
        components.host = config.host
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }

    private var path: String {
        switch self {
        case .search:
            return "/"
        }
    }

    private var queryItems: [URLQueryItem]? {
        switch self {
        case .search(let apiKey, let searchString):
            return [
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "s", value: searchString)
            ]
        }
    }
}


