
import Foundation

protocol ImageNetworkManagerProtocol {
    func fetchImageData(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

final class ImageNetworkManager: ImageNetworkManagerProtocol {
    func fetchImageData(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(.errorInServer))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            completion(.success(data))
        }.resume()
    }
}
