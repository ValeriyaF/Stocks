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

    func updateStocks()

    func showLoadingMoreIndicator()

    func hideLoadingMoreIndicator()

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

    private lazy var footerView: LoadMoreFooter = {
        LoadMoreFooter()
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        presenter?.viewDidLoad()
    }

    // MARK: - IStocksListView

    func updateStocks() {
        tableView.reloadData()
    }

    func showLoadingMoreIndicator() {
        footerView.isLoading = true
        tableView.tableFooterView = footerView
    }

    func hideLoadingMoreIndicator() {
        footerView.isLoading = false
        tableView.tableFooterView = nil
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
        return presenter?.itemsCount() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter = presenter,
            let cell = tableView.dequeueReusableCell(withIdentifier: stockCellReuseId) as? StockCell else {
            fatalError("Unable to dequeue a cell with identifier \(stockCellReuseId)")
        }

        let stockDM = presenter.stockDataModel(index: indexPath.row)
        let cellVM = StockCellViewModel(with: stockDM, isEmphasized: indexPath.row % 2 == 0)
        cell.configureUI(with: cellVM)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let presenter = presenter, !presenter.isLoading else {
            return
        }

        if (indexPath.row == presenter.itemsCount() - 1) && presenter.loadMoreEnable {
            presenter.scrolledToTableBottom()
        }
    }

}

// MARK: - UITableViewDelegate

extension StocksListViewController: UITableViewDelegate {
    // TODO: - Implement
}
