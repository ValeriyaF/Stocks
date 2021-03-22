//
//  LoadMoreFooter.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 05.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import SnapKit

final class LoadMoreFooter: UIView {

    var isLoading = false {
        didSet {
            updateIndicatorState()
        }
    }

    private var activityIndicator: UIActivityIndicatorView = {
        let frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
        return UIActivityIndicatorView(frame: frame)
    }()

    // MARK: - Initialization

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 40))

        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateIndicatorState() {
        isLoading
            ? activityIndicator.startAnimating()
            : activityIndicator.stopAnimating()
    }
}
