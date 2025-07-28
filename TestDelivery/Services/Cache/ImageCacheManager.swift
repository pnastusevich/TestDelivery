import UIKit

protocol ImageCacheManagerProtocol {
    func get(forKey key: URL) -> UIImage?
    func set(_ image: UIImage, forKey key: URL)
}

final class ImageCacheManager: ImageCacheManagerProtocol {
    private let cache = NSCache<NSURL, UIImage>()

    func get(forKey key: URL) -> UIImage? {
        cache.object(forKey: key as NSURL)
    }

    func set(_ image: UIImage, forKey key: URL) {
        cache.setObject(image, forKey: key as NSURL)
    }
}
