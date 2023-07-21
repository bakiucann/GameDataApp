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

        ImageManager.shared.loadImage(from: url) { [weak self] image in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.image = image
            }
        }
    }

}
