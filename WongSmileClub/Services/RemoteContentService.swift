import Foundation

struct RemoteContentResult<T> {
    let items: [T]
    let lastUpdated: Date?
}

struct RemoteContentService {
    private let fileManager: FileManager
    private let session: URLSession
    private let cacheDirectory: URL

    init(fileManager: FileManager = .default, session: URLSession = .shared) {
        self.fileManager = fileManager
        self.session = session
        let baseDirectory = (try? fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)) ?? fileManager.temporaryDirectory
        cacheDirectory = baseDirectory.appendingPathComponent("ContentCache", isDirectory: true)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }

    func fetchContent<T: Decodable>(
        url: URL?,
        cacheFileName: String,
        decoder: JSONDecoder,
        bundleFallback: () -> [T]
    ) async -> RemoteContentResult<T> {
        if let url {
            do {
                let (data, _) = try await session.data(from: url)
                let items = try decoder.decode([T].self, from: data)
                writeCache(data, fileName: cacheFileName)
                return RemoteContentResult(items: items, lastUpdated: Date())
            } catch {
                return loadCachedOrBundle(cacheFileName: cacheFileName, decoder: decoder, bundleFallback: bundleFallback)
            }
        }

        return loadCachedOrBundle(cacheFileName: cacheFileName, decoder: decoder, bundleFallback: bundleFallback)
    }

    private func loadCachedOrBundle<T: Decodable>(
        cacheFileName: String,
        decoder: JSONDecoder,
        bundleFallback: () -> [T]
    ) -> RemoteContentResult<T> {
        if let cached = readCache(fileName: cacheFileName) {
            do {
                let items = try decoder.decode([T].self, from: cached.data)
                return RemoteContentResult(items: items, lastUpdated: cached.lastUpdated)
            } catch {
                return RemoteContentResult(items: bundleFallback(), lastUpdated: nil)
            }
        }

        return RemoteContentResult(items: bundleFallback(), lastUpdated: nil)
    }

    private func writeCache(_ data: Data, fileName: String) {
        let url = cacheDirectory.appendingPathComponent(fileName)
        try? data.write(to: url, options: [.atomic])
    }

    private func readCache(fileName: String) -> (data: Data, lastUpdated: Date?)? {
        let url = cacheDirectory.appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: url) else { return nil }
        let attributes = try? fileManager.attributesOfItem(atPath: url.path)
        let modifiedAt = attributes?[.modificationDate] as? Date
        return (data, modifiedAt)
    }
}
