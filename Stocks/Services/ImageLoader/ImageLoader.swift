//
//  ImageLoader.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 07.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import UIKit

final class ImageLoader {

    static let shared = ImageLoader()

    private let imageCache = NSCache<NSString, NSData>()

    private init() { }

    func getImage(imageURL urlString: String, for imageView: LoadableImageView) {
        if let imageData = imageCache.object(forKey: urlString as NSString),
            let image = UIImage(data: imageData as Data) {
            if imageView.imageURL == urlString {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
            return
        }

        load(urlString: urlString, imageView: imageView)
    }

    // MARK: - Private methods

    private func load(urlString: String, imageView: LoadableImageView) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                // TODO: -
                assertionFailure()
            }

            if let data = data,
                let image = UIImage(data: data) {
                self?.imageCache.setObject(data as NSData, forKey: url.absoluteString as NSString)
                if imageView.imageURL == url.absoluteString {
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }
            }
        }.resume()
    }
}
