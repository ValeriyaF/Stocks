//
//  StockCell.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 22.02.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import SnapKit

final class StockCell: UITableViewCell {

    var viewModel: StockCellViewModel?

    // MARK: - UI

    private let roundedView: UIView = {
        let view = UIView()
        return view
    }()

    private let logoImage: LoadableImageView = {
        let imageView = LoadableImageView()
        imageView.layer.cornerRadius = 12.0
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 0.3
        return imageView
    }()

    private let favoriteImageView: UIImageView = {
        let imageView = UIImageView()
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

    private let dayDeltaLabel: UILabel = {
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
        stackView.addArrangedSubview(dayDeltaLabel)
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
            $0.size.equalTo(Constants.logoSize).priority(.high)
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
            $0.width.equalTo(170)
        }

        roundedView.addSubview(favoriteImageView)
        favoriteImageView.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalTo(displaySymbolLabel.snp.trailing).offset(6)
        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(favoriteImageViewTapped))
        favoriteImageView.isUserInteractionEnabled = true
        favoriteImageView.addGestureRecognizer(tapGestureRecognizer)

        roundedView.addSubview(priceStackView)
        priceStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(17)
            $0.bottom.equalToSuperview().inset(14)
        }

        layoutIfNeeded()
    }

    func configureUI() {
        guard let viewModel = viewModel else { return }

        if let logoImageString = viewModel.logoImageString {
            logoImage.getImage(urlString: logoImageString)
        } else {
            logoImage.image = nil
        }

        roundedView.backgroundColor = viewModel.isEmphasized
            ? .init(rgb: 0xF0F4F7)
            : .white
        displaySymbolLabel.text = viewModel.displaySymbol
        descriptionLabel.text = viewModel.description
        currentPriceLabel.text = viewModel.currentPrice
        dayDeltaLabel.text = viewModel.dayDelta
        dayDeltaLabel.textColor = viewModel.isNegativeDayDelta ? .init(rgb: 0xB22424) : .init(rgb: 0x24B25D)
        favoriteImageView.image = viewModel.isFavourite ? Images.favorite : Images.unfavorite
    }

    func updatePrice() {
        guard let viewModel = viewModel else { return }

        currentPriceLabel.text = viewModel.currentPrice
        dayDeltaLabel.text = viewModel.dayDelta
    }

}

// MARK: - Actions

extension StockCell {

    @IBAction private func favoriteImageViewTapped() {
        guard let viewModel = viewModel else { return }

        viewModel.favouriteStateChanged()
        favoriteImageView.image = viewModel.isFavourite ? Images.favorite : Images.unfavorite
    }
}

private enum Images {

    static let favorite: UIImage = UIImage(named: "yellowStar")!
    static let unfavorite: UIImage = UIImage(named: "grayStar")!

}

private enum Constants {
    static let logoSize: CGSize = CGSize(width: 52.0, height: 52.0)
    static let logoOffset: CGFloat = 8.0
}
