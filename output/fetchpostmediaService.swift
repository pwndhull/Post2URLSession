import Foundation

// MARK: - fetchpostmediaService
class fetchpostmediaService {

// Network request to perform GET localhost:3000/uploads/1726773408662.png
static func performRequest(completion: @escaping (Result<Data, NetworkError>) -> Void) {

// Build the URL request
guard let url = URL(string: "localhost:3000/uploads/1726773408662.png") else {
    completion(.failure(.invalidURL))
    return
}

var request = URLRequest(url: url)
request.httpMethod = "GET"

// Add headers
let headers: [String: String] = [
]
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