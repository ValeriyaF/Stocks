//
//  StocksListViewController.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 22.02.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import UIKit
import SnapKit

protocol IStocksListView: class {

}

final class StocksListViewController: UIViewController, IStocksListView {

    // MARK: - Properties

    let stockCellReuseId = String(describing: type(of: StockCell.self))
    var presenter: IStocksListPresenter?

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none

        tableView.register(StockCell.self, forCellReuseIdentifier: stockCellReuseId)
        tableView.estimatedRowHeight = 70.0
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        presenter?.viewDidLoad()
    }

}

// MARK: - UI Managment

extension StocksListViewController {

    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

}

// MARK: - UITableViewDataSource

extension StocksListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: stockCellReuseId) as? StockCell else {
            fatalError("Unable to dequeue a cell with identifier \(stockCellReuseId)")
        }

        cell.configureUI(with: StockCellViewModel(logoImage: nil,
                                                  isFavourite: false,
                                                  isEmphasized: indexPath.row % 2 == 0, // TODO: - make more readable
                                                  displaySymbol: "YNDX",
                                                  description: "Yandex, LLC",
                                                  currentPrice: "$3 204",
                                                  dayPrice: "+$0.12 (1,15%)"))
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let presenter = presenter else {
            return
        }

        if indexPath.row == presenter.itemsCount() - 2 {
            // TODO: load more stocks
        }
    }

}

// MARK: - UITableViewDelegate

extension StocksListViewController: UITableViewDelegate {
    // TODO: - Implement
}
