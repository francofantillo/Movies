import Foundation

struct APIErrorMessage: Codable {
    var response: Bool
    var message: String?

    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case error = "Error"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseString = try container.decode(String.self, forKey: .response)
        response = responseString.lowercased() == "true"
        message = try container.decodeIfPresent(String.self, forKey: .error)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let responseString = response ? "True" : "False"
        try container.encode(responseString, forKey: .response)
        try container.encode(message, forKey: .error)
    }
}

enum APIErrors: Error {
    case invalidRequestError(String)
    case transportError(String)
    case invalidResponseError
    case validationError(String)
    case serverError(String)
    case tooManyResultsError
    case unknownError

    var localizedDescription: String {
        switch self {
        case .invalidRequestError(let message):
            return "Invalid request: \(message)"
        case .transportError(let message):
            return "Transport error: \(message)"
        case .invalidResponseError:
            return "Invalid response from server."
        case .validationError(let message):
            return "Validation error: \(message)"
        case .serverError(let message):
            return "Server error: \(message)"
        case .tooManyResultsError:
            return "Enter at least three characters to perform search."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}

extension APIErrors: LocalizedError {
    public var errorDescription: String? {
        return self.localizedDescription
    }
}
