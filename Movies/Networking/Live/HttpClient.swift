import Foundation

//MARK: Protocol for MOCK/Real
protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

//MARK: HttpClient Implementation
class HttpClient {
    
    private let session: URLSessionProtocol
    
    private var dataTask: URLSessionDataTaskProtocol!
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func getData(url: URL) async throws -> Data {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return try await withCheckedThrowingContinuation { continuation in
            
            dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
                
                guard let self1 = self else {
                    continuation.resume(with: .failure(APIErrors.validationError("Self is out of scope.")))
                    return
                }
                
                if let error = error {
                    if error.localizedDescription == "cancelled" {
                        return // We don't need to alert the user of this.
                    }
                    continuation.resume(with: .failure(APIErrors.transportError(error.localizedDescription)))
                    return
                }
                
                switch self1.checkResponse(response: response, data: data) {
                case .failure(let error):
                    continuation.resume(with: .failure(error))
                case .success(let data):
                    continuation.resume(with: .success(data))
                }
            }
            dataTask.resume()
        }
    }
    
    private func checkResponse(response: URLResponse?, data: Data?) -> Result<Data, APIErrors> {
        
        guard let urlResponse = response as? HTTPURLResponse else {
            return .failure(APIErrors.invalidResponseError)
        }

        if (200..<300) ~= urlResponse.statusCode {
            guard let data = data else { return .failure(APIErrors.validationError("Unable to decode API error.")) }
            
            if let dataString = String(data: data, encoding: .utf8) {
                print("Response Data String: \(dataString)")
            }
            do {
                let apiError = try JSONDecoder().decode(APIErrorMessage.self, from: data)
                if apiError.response == false {
                    return .failure(APIErrors.invalidRequestError(apiError.message ?? "Unknown"))
                }
            } catch {
                return .failure(APIErrors.validationError("Unable to decode API error."))
            }
            
            return .success(data)
        } else {
            guard let data = data else { return .failure(APIErrors.validationError("Unable to decode API error.")) }
            
            do {
                if let dataString = String(data: data, encoding: .utf8) {
                    print("Response Data String: \(dataString)")
                }

                let apiError = try JSONDecoder().decode(APIErrorMessage.self, from: data)
                
                if (400..<499) ~= urlResponse.statusCode {
                    return .failure(APIErrors.transportError("Failed with status code: \(urlResponse.statusCode). Reason: \(apiError.message ?? "Unknown")"))
                }
                
                if 500 <= urlResponse.statusCode {
                    return .failure(APIErrors.serverError("Failed with status code: \(urlResponse.statusCode). Reason: \(apiError.message ?? "Unknown")"))
                }
                
            } catch {
                return .failure(APIErrors.validationError("Unable to decode API error."))
            }
        }
        return .failure(APIErrors.invalidResponseError)
    }
}

//MARK: Conform the protocol
extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
