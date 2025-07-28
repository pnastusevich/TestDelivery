import Foundation

protocol BuilderURLProtocol {
    func buildURL(enpoint: EndpointProtocol) -> URL?
}

final class BuilderURL: BuilderURLProtocol {
    func buildURL(enpoint: EndpointProtocol) -> URL? {
        var components = URLComponents()
        components.scheme = enpoint.scheme
        components.host = enpoint.host
        components.path = enpoint.path
        guard let url = components.url else { return nil }
        
        return url
    }
}
