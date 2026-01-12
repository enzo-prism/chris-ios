import XCTest
@testable import WongSmileClub

final class FormspreeClientTests: XCTestCase {
    func testJSONRequestBuildsBodyAndHeaders() throws {
        let client = FormspreeClient(session: .shared)
        let url = URL(string: "https://example.com/submit")!
        let request = try client.makeJSONRequest(endpointURL: url, payload: ["name": "Taylor", "rating": 5])

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")

        let body = try XCTUnwrap(request.httpBody)
        let json = try JSONSerialization.jsonObject(with: body) as? [String: Any]
        XCTAssertEqual(json?["name"] as? String, "Taylor")
        XCTAssertEqual(json?["rating"] as? Int, 5)
    }

    func testMultipartRequestContainsFieldsAndFile() throws {
        let client = FormspreeClient(session: .shared)
        let url = URL(string: "https://example.com/upload")!
        let request = try client.makeMultipartRequest(
            endpointURL: url,
            fields: ["name": "Taylor"],
            fileData: Data([0x01, 0x02, 0x03]),
            fileName: "smile.jpg",
            mimeType: "image/jpeg"
        )

        XCTAssertEqual(request.httpMethod, "POST")
        let contentType = request.value(forHTTPHeaderField: "Content-Type") ?? ""
        XCTAssertTrue(contentType.contains("multipart/form-data; boundary="))

        let bodyString = String(data: request.httpBody ?? Data(), encoding: .utf8) ?? ""
        XCTAssertTrue(bodyString.contains("name=\"name\""))
        XCTAssertTrue(bodyString.contains("Taylor"))
        XCTAssertTrue(bodyString.contains("filename=\"smile.jpg\""))
        XCTAssertTrue(bodyString.contains("Content-Type: image/jpeg"))
    }
}
