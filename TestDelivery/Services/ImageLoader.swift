
import UIKit

protocol ImageLoaderProtocol {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

final class ImageLoader: ImageLoaderProtocol {
    private let networkManager: ImageNetworkManagerProtocol
    private let cacheManager: ImageCacheManagerProtocol
    
    static let shared = ImageLoader()

    private init(networkManager: ImageNetworkManagerProtocol = ImageNetworkManager(),
         cacheManager: ImageCacheManagerProtocol = ImageCacheManager()) {
        self.networkManager = networkManager
        self.cacheManager = cacheManager
    }

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cacheManager.get(forKey: url) {
            completion(cachedImage)
            return
        }

        networkManager.fetchImageData(from: url) { [weak self] result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                if let image = image {
                    self?.cacheManager.set(image, forKey: url)
                }
                DispatchQueue.main.async {
                    completion(image)
                }

            case .failure:
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
