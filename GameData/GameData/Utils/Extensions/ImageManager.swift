//
//  ImageManager.swift
//  GameData
//
//  Created by Baki Uçan on 21.07.2023.
//

import UIKit

class ImageManager {
    static let shared = ImageManager()
    private let imageCache = NSCache<NSURL, UIImage>()

    private init() { }

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        // Önbellekte resim var mı kontrol edin
        if let cachedImage = imageCache.object(forKey: url as NSURL) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }

        // URLSession kullanarak resmi indirin
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let downloadedImage = UIImage(data: data),
                  error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            // İndirilen resmi önbelleğe alın
            self.imageCache.setObject(downloadedImage, forKey: url as NSURL)

            DispatchQueue.main.async {
                completion(downloadedImage)
            }
        }
        task.resume()
    }

    func cancelImageLoad(from url: URL) {
        // Eğer gerekirse implemente edilebilir
    }
}
