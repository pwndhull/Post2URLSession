import Foundation

// MARK: - Create_PostService
class Create_PostService {

// Network request to perform POST localhost:3000/api/posts/create
static func performRequest(completion: @escaping (Result<Data, NetworkError>) -> Void) {

// Build the URL request
guard let url = URL(string: "localhost:3000/api/posts/create") else {
    completion(.failure(.invalidURL))
    return
}

var request = URLRequest(url: url)
request.httpMethod = "POST"

// Add headers
let headers: [String: String] = [
    "Content-Type": "application/json",
]
// Add request body
let body: [String: Any] = [
// Perform network request
let task = URLSession.shared.dataTask(with: request) { data, response, error in
    if let error = error {
        completion(.failure(.networkError(error)))
        return
    }

    guard let data = data else {
        completion(.failure(.noData))
        return
    }

    completion(.success(data))
}

task.resume()
}
}

// MARK: - NetworkError
enum NetworkError: Error {
    case invalidURL
    case networkError(Error)
    case noData
    case decodingError
}