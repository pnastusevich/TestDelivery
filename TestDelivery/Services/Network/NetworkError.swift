import Foundation

enum NetworkError: Error {
    case noData
    case decodingFailed
    case invalidURL
    case unauthorized
    case errorInServer
    case emptyResponse
}
