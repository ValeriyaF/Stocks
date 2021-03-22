//
//  LoadableImageView.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 07.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import UIKit

final class LoadableImageView: UIImageView {

    var imageURL: String?

    func getImage(urlString: String) {
        image = nil
        imageURL = urlString
        ImageLoader.shared.getImage(imageURL: urlString, for: self)
    }

}
