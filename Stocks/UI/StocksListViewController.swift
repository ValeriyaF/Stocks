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

    func endRefreshing()

    func updateVisibleStocksPrice()

    func showLoadingMoreIndicator()

    func hideLoadingMoreIndicator()

    func showErrorAlert(error: Error)

}

final class StocksListViewController: UIViewController, IStocksListView {

    // MARK: - Properties

    var presenter: IStocksListPresenter?

    private let stockCellReuseId = String(describing: type(of: StockCell.self))
    private var searchTask: DispatchWorkItem?

    // MARK: - UI

    private let searchController = UISearchController(searchResultsController: nil)
    private lazy var footerView: LoadMoreFooter = LoadMoreFooter()
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshStocks), for: .valueChanged)
        return control
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none

        tableView.register(StockCell.self, forCellReuseIdentifier: stockCellReuseId)
        tableView.estimatedRowHeight = 70.0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        return tableView
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

}

// MARK: - IStocksListView

extension StocksListViewController {

    func updateStocks() {
        tableView.reloadData()
    }

    func endRefreshing() {
        tableView.refreshControl?.endRefreshing()
    }

    func updateVisibleStocksPrice() {
        tableView.indexPathsForVisibleRows?.forEach { indexPath in
            guard let presenter = presenter,
                let cell = tableView.cellForRow(at: indexPath) as? StockCell else {
                    return
            }

            let stockDM = presenter.stockDataModel(index: indexPath.row)
            let favouriteStateChangedCompletion = { presenter.favouriteStateChanged(stockSymbol: $0) }
            let cellVM = StockCellViewModel(with: stockDM,
                                            isEmphasized: indexPath.row % 2 == 0,
                                            favouriteStateChangedCompletion: favouriteStateChangedCompletion)
            cell.viewModel = cellVM
            cell.updatePrice()
        }
    }

    func showLoadingMoreIndicator() {
        footerView.isLoading = true
        tableView.tableFooterView = footerView
    }

    func hideLoadingMoreIndicator() {
        footerView.isLoading = false
        tableView.tableFooterView = nil
    }

    func showErrorAlert(error: Error) {
        let alert = UIAlertController(title: "Smth went wrong",
                                      message: error.localizedDescription,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

// MARK: - UI Managment

extension StocksListViewController {

    private func setupUI() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Stocks"
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Find company or ticker"
        searchController.definesPresentationContext = true
        navigationItem.searchController = searchController

        view.backgroundColor = .white

        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

}

// MARK: - Actions

extension StocksListViewController {

    @IBAction private func segmentChanged() {
        presenter?.stocksListTypeChanged(isFavouriteMode:
            segmentedControl.selectedSegmentIndex == SegmentedControlItem.favourites.rawValue)
    }

    @IBAction private func refreshStocks() {
        presenter?.refreshStocks()
    }

}

// MARK: - UITableViewDataSource

extension StocksListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return segmentedControl
    }

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
        cell.configureUI()
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

extension StocksListViewController: UITableViewDelegate { }

// MARK: - UISearchResultsUpdating

extension StocksListViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        self.searchTask?.cancel()
        guard let searchPhrase = searchController.searchBar.text else {
            return
        }

        let task = DispatchWorkItem { [weak self] in
            self?.presenter?.searchResultsUpdated(searchPhrase: searchPhrase)
        }
        self.searchTask = task

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)
    }

}

// MARK: - UISearchControllerDelegate

extension StocksListViewController: UISearchControllerDelegate {

    func willPresentSearchController(_ searchController: UISearchController) {
        segmentedControl.isEnabled = false
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        presenter?.searchFinished()
        segmentedControl.isEnabled = true
    }

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
