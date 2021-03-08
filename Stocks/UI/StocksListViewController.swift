//
//  StocksListViewController.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 22.02.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import UIKit
import SnapKit
import CoreData

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

    private let footerView: LoadMoreFooter = {
        LoadMoreFooter()
    }()

    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [SegmentedControlItem.stocks.stringValue,
                                                 SegmentedControlItem.favourites.stringValue])
        control.selectedSegmentIndex = SegmentedControlItem.stocks.rawValue
        control.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return control
    }()

    private var stackView: UIStackView?

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
        navigationController?.navigationBar.isHidden =  true
        view.backgroundColor = .white

        let stackView = UIStackView(arrangedSubviews: [segmentedControl, tableView])
        stackView.axis = .vertical
        self.stackView = stackView

        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(65.0)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }

}

// MARK: - Actions

extension StocksListViewController {

    @IBAction private func segmentChanged() {
        presenter?.stocksListTypeChanged(isFavouriteMode:
            segmentedControl.selectedSegmentIndex == SegmentedControlItem.favourites.rawValue)
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
        let favouriteStateChangedCompletion = { presenter.favouriteStateChanged(stockSymbol: $0) }
        let cellVM = StockCellViewModel(with: stockDM,
                                        isEmphasized: indexPath.row % 2 == 0,
                                        favouriteStateChangedCompletion: favouriteStateChangedCompletion)
        cell.viewModel = cellVM
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

private enum SegmentedControlItem: Int {

    case stocks
    case favourites

    var stringValue: String {
        switch self {
        case .stocks:
            return "Stocks"
        case .favourites:
            return "Favourite"
        }
    }

}
