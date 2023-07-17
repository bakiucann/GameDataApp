//
//  UIImageView+Extension.swift
//  GameData
//
//  Created by Baki Uçan on 17.07.2023.
//

import UIKit

extension UIImageView {

    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        if let placeholderImage = placeholder {
            self.image = placeholderImage
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data) {
                    self.image = downloadedImage
                }
            }
        }.resume()
    }

}
