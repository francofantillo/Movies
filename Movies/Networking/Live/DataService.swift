import Foundation

protocol DataServiceProtocol {
    func search<T: Decodable>(searchString: String, page: Int) async throws -> [T]
    func getImageData(url: URL) async throws -> Data
}

class DataService: DataServiceProtocol {

    let client: HttpClient
    private let apiKey = "684a81cf"
    
    init(client: HttpClient) {
        self.client = client
    }

    func search<T: Decodable>(searchString: String, page: Int) async throws -> T {
        let config = APIConfig.production
        let endpoint = APIEndpoint.search(apiKey: apiKey, searchString: searchString, page: page)
        
        guard let url = endpoint.url(with: config) else {
            throw APIErrors.invalidRequestError("URL not valid")
        }
        
        let data = try await client.getData(url: url)
        let response = try JSONDecoder().decode(T.self, from: data)
        return response
    }

    func getImageData(url: URL) async throws -> Data {
        return try await client.getData(url: url)
    }
}
