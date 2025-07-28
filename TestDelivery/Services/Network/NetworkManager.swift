import Foundation

protocol NetworkManagerProtocol {
    func fetchMenu(completion: @escaping (Result<MenuResponse, NetworkError>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    
    private let builderURL: BuilderURLProtocol
    
    init(builderURL: BuilderURLProtocol) {
        self.builderURL = builderURL
    }
    
    func fetchMenu(completion: @escaping (Result<MenuResponse, NetworkError>) -> Void) {
        let endpoint = Endpoint.all
        guard let url = builderURL.buildURL(enpoint: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil {
                completion(.failure(.errorInServer))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let model = try JSONDecoder().decode(MenuResponse.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }.resume()
    }
}
