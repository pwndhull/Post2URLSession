import Foundation

// MARK: - UpdateUserService
class UpdateUserService {

// Network request to perform PUT localhost:3000/api/users/5
static func performRequest(completion: @escaping (Result<Data, NetworkError>) -> Void) {

// Build the URL request
guard let url = URL(string: "localhost:3000/api/users/5") else {
    completion(.failure(.invalidURL))
    return
}

var request = URLRequest(url: url)
request.httpMethod = "PUT"

// Add headers
let headers: [String: String] = [
]// Add request body
let body: [String: Any] = [
    "bio": "this is sample bio",
    "profilePhoto": "No image",
    "relationshipStatus": "Taken",
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