//
//  StockCell.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 22.02.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import SnapKit

struct StockCellViewModel {

    var logoImage: UIImage? 
    var isEmphasized: Bool
    var displaySymbol: String
    var description: String
    var currentPrice: String
    var dayPrice: String
}

final class StockCell: UITableViewCell {

    // MARK: - UI

    private let roundedView: UIView = {
        let view = UIView()
        return view
    }()

    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 12.0
        return imageView
    }()

    private let favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .yellow
        return imageView
    }()

    private let displaySymbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 18.0) // TODO: add consts
        // TODO: add hugginhg priority constr
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Medium", size: 12.0) // TODO: add consts and use R.Swift
        // TODO: add hugginhg priority constr
        return label
    }()

    private let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 18.0) // TODO: add consts
        label.textAlignment = .right
        // TODO: add hugginhg priority constr
        return label
    }()

    private let dayPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Medium", size: 12.0) // TODO: add consts
        label.textAlignment = .right
        // TODO: add hugginhg priority constr
        return label
    }()

    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(currentPriceLabel)
        stackView.addArrangedSubview(dayPriceLabel)
        return stackView
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func configureUI(with viewModel: StockCellViewModel) {
        roundedView.backgroundColor = viewModel.isEmphasized
            ? UIColor(red: 240/255, green: 244/255, blue: 247/255, alpha: 1)
            : .white
        logoImage.image = viewModel.logoImage // TODO: https://medium.com/flawless-app-stories/reusable-image-cache-in-swift-9b90eb338e8d
        displaySymbolLabel.text = viewModel.displaySymbol
        descriptionLabel.text = viewModel.description
        dayPriceLabel.text = viewModel.dayPrice
        currentPriceLabel.text = viewModel.currentPrice
    }

}

// MARK: - UI Managment

extension StockCell {

    private func setupUI() {
        selectionStyle = .none

        roundedView.layer.cornerRadius = 16.0

        contentView.addSubview(roundedView)
        roundedView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(8)
        }

        roundedView.addSubview(logoImage)
        logoImage.snp.makeConstraints {
            $0.size.equalTo(Constants.logoSize).priority(.medium)
            $0.top.equalToSuperview().offset(Constants.logoOffset)
            $0.bottom.equalToSuperview().inset(Constants.logoOffset)
            $0.leading.equalToSuperview().offset(Constants.logoOffset)
        }

        roundedView.addSubview(displaySymbolLabel)
        displaySymbolLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalTo(logoImage.snp.trailing).offset(12)
        }

        roundedView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(displaySymbolLabel.snp.bottom)
            $0.leading.equalTo(displaySymbolLabel)
        }

        roundedView.addSubview(favoriteImageView)
        favoriteImageView.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.top.equalToSuperview().offset(17)
            $0.leading.equalTo(displaySymbolLabel.snp.trailing).offset(6)
        }

        roundedView.addSubview(priceStackView)
        priceStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(17)
            $0.bottom.equalToSuperview().inset(14)
        }

        layoutIfNeeded()
    }

}

private enum Constants {
    static let logoSize: CGSize = CGSize(width: 52.0, height: 52.0)
    static let logoOffset: CGFloat = 8.0
}
