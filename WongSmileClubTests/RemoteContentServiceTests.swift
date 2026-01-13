import XCTest
@testable import WongSmileClub

final class RemoteContentServiceTests: XCTestCase {
    struct Dummy: Codable, Equatable {
        let id: String
    }

    final class FailingURLProtocol: URLProtocol {
        override class func canInit(with request: URLRequest) -> Bool { true }
        override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
        override func startLoading() {
            let error = URLError(.notConnectedToInternet)
            client?.urlProtocol(self, didFailWithError: error)
        }
        override func stopLoading() {}
    }

    func testFetchFallsBackToBundleOnFailure() async {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [FailingURLProtocol.self]
        let session = URLSession(configuration: config)
        let service = RemoteContentService(session: session)
        let url = URL(string: "https://example.com/dummy.json")!

        let result = await service.fetchContent(
            url: url,
            cacheFileName: "dummy.json",
            decoder: JSONDecoder()
        ) {
            [Dummy(id: "fallback")]
        }

        XCTAssertEqual(result.items, [Dummy(id: "fallback")])
        XCTAssertNil(result.lastUpdated)
    }
}
