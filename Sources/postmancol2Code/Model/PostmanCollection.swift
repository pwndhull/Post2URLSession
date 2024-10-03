import Foundation

// MARK: - Postman Collection Model

struct PostmanCollection: Codable {
    let info: Info
    let MainItem: [MainItem]?
    let variable: [Variable]

    private enum CodingKeys: String, CodingKey {
        case info = "info"
        case MainItem = "item"
        case variable = "variable"
    }
}

struct Info: Codable {
    let PostmanId: String
    let name: String
    let schema: String
    let ExporterId: String

    private enum CodingKeys: String, CodingKey {
        case PostmanId = "_postman_id"
        case name = "name"
        case schema = "schema"
        case ExporterId = "_exporter_id"
    }
}

struct MainItem: Codable {
    let name: String
    let item: [Item]?

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case item = "item"
    }
}

struct Item: Codable {
    let name: String
    let request: Request
//    let response: ResponseType?

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case request = "request"
//        case response = "response"
    }
}

// MARK: - Request and Body
struct Request: Codable {
    let method: String
    let header: [Headers]
    let url: RequestURL
    let body: RequestBody?

    private enum CodingKeys: String, CodingKey {
        case method = "method"
        case header = "header"
        case url = "url"
        case body = "body"
    }
}


// Enum to handle both string and dictionary for the URL
enum RequestURL: Codable {
    case string(String)
    case dictionary(URLDictionary)

    // Custom decoding logic to handle both cases
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        // If it's a string
        if let urlString = try? container.decode(String.self) {
            self = .string(urlString)
        }
        // If it's a dictionary
        else if let urlDict = try? container.decode(URLDictionary.self) {
            self = .dictionary(urlDict)
        }
        // If neither, throw a decoding error
        else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "URL is neither a string nor a dictionary")
        }
    }

    // Custom encoding logic to handle both cases
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let urlString):
            try container.encode(urlString)
        case .dictionary(let urlDict):
            try container.encode(urlDict)
        }
    }
}

// Struct to handle the dictionary format of the URL
struct URLDictionary: Codable {
    let raw: String
    let host: [String]
    let port: String
    let path: [String]
    let query: [URLQuery]

    private enum CodingKeys: String, CodingKey {
        case raw = "raw"
        case host = "host"
        case port = "port"
        case path = "path"
        case query = "query"
    }
}

struct URLQuery: Codable {
    let key: String
    let value: String

    private enum CodingKeys: String, CodingKey {
        case key = "key"
        case value = "value"
    }
}

struct RequestBody: Codable {
    let mode: String
    let urlencoded: [Urlencoded]?

    private enum CodingKeys: String, CodingKey {
        case mode = "mode"
        case urlencoded = "urlencoded"
    }
}

struct Urlencoded: Codable {
    let key: String
    let value: String
    let type: String

    private enum CodingKeys: String, CodingKey {
        case key = "key"
        case value = "value"
        case type = "type"
    }
}

// MARK: - Headers and Other Structures

struct Headers: Codable {
    let key: String
    let value: String

    private enum CodingKeys: String, CodingKey {
        case key = "key"
        case value = "value"
    }
}

// MARK: - Response Type Handling (Known/Unknown)

enum ResponseType: Codable {
    case dictionary([String: String]?)
    case array([[String: String]])
    case string(String)

    // Custom decoding logic to handle multiple response types
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let dict = try? container.decode([String: String].self) {
            self = .dictionary(dict)
        } else if let arr = try? container.decode([[String: String]].self) {
            self = .array(arr)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        }
        // If both fail, throw an error
        else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unexpected response format")
        }
    }

    // Custom encoding logic to handle multiple response types
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .dictionary(let dict):
            try container.encode(dict)
        case .array(let arr):
            try container.encode(arr)
//        case .unknown(let unknownData):
//            // Convert the unknown data to JSON for encoding
        case .string(let string):
            let jsonData = try JSONSerialization.data(withJSONObject: String.self, options: [])
            try container.encode(jsonData)
        }
    }
}

// MARK: - Event and Script

struct Event: Codable {
    let listen: String
    let script: Script

    private enum CodingKeys: String, CodingKey {
        case listen = "listen"
        case script = "script"
    }
}

struct Script: Codable {
    let type: String
    let packages: Packages
    let exec: [String]

    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case packages = "packages"
        case exec = "exec"
    }
}

struct Packages: Codable {}

// MARK: - Variable

struct Variable: Codable {
    let key: String
    let value: String
    let type: String

    private enum CodingKeys: String, CodingKey {
        case key = "key"
        case value = "value"
        case type = "type"
    }
}
