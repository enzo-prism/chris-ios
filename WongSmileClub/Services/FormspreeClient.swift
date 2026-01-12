import Foundation
import SwiftUI

protocol FormspreeClientProtocol {
    func submitJSON(endpointURL: URL, payload: [String: Any]) async throws
    func submitMultipart(endpointURL: URL, fields: [String: String], fileData: Data, fileName: String, mimeType: String) async throws

    func makeJSONRequest(endpointURL: URL, payload: [String: Any]) throws -> URLRequest
    func makeMultipartRequest(endpointURL: URL, fields: [String: String], fileData: Data, fileName: String, mimeType: String) throws -> URLRequest
}

enum FormspreeClientError: LocalizedError {
    case invalidResponse
    case serverError(statusCode: Int)
    case encodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Unexpected server response."
        case .serverError(let statusCode):
            return "Submission failed with status code \(statusCode)."
        case .encodingFailed:
            return "Unable to prepare your request."
        }
    }
}

struct FormspreeClient: FormspreeClientProtocol {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func submitJSON(endpointURL: URL, payload: [String: Any]) async throws {
        let request = try makeJSONRequest(endpointURL: endpointURL, payload: payload)
        let (_, response) = try await session.data(for: request)
        try validate(response)
    }

    func submitMultipart(endpointURL: URL, fields: [String: String], fileData: Data, fileName: String, mimeType: String) async throws {
        let request = try makeMultipartRequest(endpointURL: endpointURL, fields: fields, fileData: fileData, fileName: fileName, mimeType: mimeType)
        let (_, response) = try await session.data(for: request)
        try validate(response)
    }

    func makeJSONRequest(endpointURL: URL, payload: [String: Any]) throws -> URLRequest {
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        } catch {
            throw FormspreeClientError.encodingFailed
        }
        return request
    }

    func makeMultipartRequest(endpointURL: URL, fields: [String: String], fileData: Data, fileName: String, mimeType: String) throws -> URLRequest {
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = Data()

        for (key, value) in fields {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }

        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n")
        body.append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(fileData)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")

        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        return request
    }

    private func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw FormspreeClientError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw FormspreeClientError.serverError(statusCode: httpResponse.statusCode)
        }
    }
}

private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

struct FormspreeClientKey: EnvironmentKey {
    static let defaultValue: FormspreeClientProtocol = FormspreeClient()
}

extension EnvironmentValues {
    var formspreeClient: FormspreeClientProtocol {
        get { self[FormspreeClientKey.self] }
        set { self[FormspreeClientKey.self] = newValue }
    }
}
