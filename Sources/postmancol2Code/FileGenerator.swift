import Foundation

// MARK: - File Generator

class FileGenerator {

    let outputDirectory: String

    init(outputDirectory: String) {
        self.outputDirectory = outputDirectory
    }

    // Function to generate API code from a Postman collection
    func generateAPICode(from postmanCollection: PostmanCollection) throws {
        // Ensure MainItems exist in the collection
        guard let mainItems = postmanCollection.MainItem else { return }
        
        for mainItem in mainItems {
            guard let items = mainItem.item else { continue }
            
            for item in items {
                try generateServiceFile(for: item)
            }
        }
    }

    // Function to generate a service file for each Postman Item
    private func generateServiceFile(for item: Item) throws {
        let request = item.request
        let method = request.method
        let url = request.url
        let headers = request.header
        let body = request.body
        
        let serviceName = sanitizeFileName(item.name)
        let filePath = "\(outputDirectory)/\(serviceName)Service.swift"
        let serviceContent = generateServiceContent(for: item, method: method, url: url, headers: headers, body: body)
        
        // Write the service file
        try serviceContent.write(toFile: filePath, atomically: true, encoding: .utf8)
        print("Generated service file at: \(filePath)")
    }

    // Helper function to generate service content for each API
    private func generateServiceContent(for item: Item, method: String, url: RequestURL, headers: [Headers], body: RequestBody?) -> String {
        let serviceName = sanitizeFileName(item.name)
        let urlString = generateURLString(from: url)

        var serviceContent = """
                import Foundation
                
                // MARK: - \(serviceName)Service
                class \(serviceName)Service {

                // Network request to perform \(method) \(urlString)
                static func performRequest(completion: @escaping (Result<Data, NetworkError>) -> Void) {

                // Build the URL request
                guard let url = URL(string: "\(urlString)") else {
                    completion(.failure(.invalidURL))
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "\(method)"

                // Add headers
                let headers: [String: String] = [
                """

        // Add headers to the request
        for header in headers {
            serviceContent += "\n    \"\(header.key)\": \"\(header.value)\","
        }
        serviceContent = serviceContent.trimmingCharacters(in: .whitespacesAndNewlines)
        serviceContent += "\n]"

        // Handle body if it's present
        if let requestBody = body {
            serviceContent += generateRequestBody(requestBody)
        }

        // Add the network call
        serviceContent += """
        
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
        """

        return serviceContent
    }

    // Helper function to generate request body content
    private func generateRequestBody(_ body: RequestBody) -> String {
        var bodyContent = """
            
            // Add request body
            let body: [String: Any] = [
            """
        
        // Add URL-encoded parameters
        if let urlEncodedParams = body.urlencoded {
            for param in urlEncodedParams {
                bodyContent += "\n    \"\(param.key)\": \"\(param.value)\","
            }
            bodyContent = bodyContent.trimmingCharacters(in: .whitespacesAndNewlines)
            bodyContent += "\n]"
        }
        
        return bodyContent
    }

    // Helper function to generate the URL string from RequestURL
    private func generateURLString(from requestURL: RequestURL) -> String {
        switch requestURL {
        case .string(let urlString):
            return urlString
        case .dictionary(let urlDict):
            let queryString = urlDict.query.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            let pathString = urlDict.path.joined(separator: "/")
            let host = urlDict.host.joined(separator: ".")
            return "http://\(host):\(urlDict.port)/\(pathString)?\(queryString)"
        }
    }

    // Helper function to sanitize file names
    private func sanitizeFileName(_ name: String) -> String {
        return name.replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "/", with: "_")
    }
}
