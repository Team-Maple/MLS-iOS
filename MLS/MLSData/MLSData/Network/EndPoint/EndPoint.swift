import Foundation

struct EndPoint {
    var baseURL: String
    let path: String
    let method: HTTPMethod
    let query: Encodable?
    let headers: [String: String]?
    let body: Encodable?
}

extension EndPoint {
    func getUrlRequest() throws -> URLRequest {
        guard var urlComponents = URLComponents(string: baseURL + path) else {
            throw URLError(.badURL)
        }

        if let query = query {
            let queryData = try JSONEncoder().encode(query)
            let dictionary = try JSONSerialization.jsonObject(with: queryData, options: []) as? [String: Any]
            urlComponents.queryItems = dictionary?.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }

        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        return request
    }
}

extension EndPoint {
    enum HTTPMethod: String {
        case GET, POST, DELETE, PUT
    }
}
