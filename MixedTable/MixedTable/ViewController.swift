//

import UIKit

class ViewController: UIViewController {
    enum Section {
        case main
    }

    private let table: UITableView = UITableView(frame: .zero, style: .insetGrouped)

    private var dataSource: UITableViewDiffableDataSource<ViewController.Section, CellModel>!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNavBar()
        configureTableView()
        configureDataSource()
    }

    // MARK: - Configuration
    private func configureNavBar() {
        title = "Task 4"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(shuffle))
    }

    private func configureTableView() {
        view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        table.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        table.delegate = self
        table.allowsMultipleSelection = true
        table.register(Cell.self, forCellReuseIdentifier: Cell.describing)
    }

    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<ViewController.Section, CellModel>(
            tableView: table,
            cellProvider: { (tableView, indexPath, cellModel) -> UITableViewCell? in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.describing, for: indexPath) as? Cell else {
                    assertionFailure("Can't dequeue as Cell")
                    return UITableViewCell()
                }
                cell.setup(model: cellModel)
                return cell
            }
        )

        dataSource.defaultRowAnimation = .automatic

        initialSetup()
    }

    private func initialSetup() {
        var snapshot = NSDiffableDataSourceSnapshot<ViewController.Section, CellModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(
            Array(1...30).map {
                CellModel(text: String($0), selectionStatus: false)
            }
        )
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    // MARK: - Editing
    private func select(cell: CellModel) {
        var snapshot = dataSource.snapshot()
        let updatedCell = cell
        updatedCell.selectionStatus = true
        snapshot.reconfigureItems([cell])
        if let firstItem = snapshot.itemIdentifiers(inSection: .main).first, firstItem != cell {
            snapshot.moveItem(cell, beforeItem: firstItem)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func deselect(cell: CellModel) {
        var snapshot = dataSource.snapshot()
        let updatedCell = cell
        updatedCell.selectionStatus = false
        snapshot.reconfigureItems([cell])
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    @objc
    private func shuffle() {
        var snapshot = NSDiffableDataSourceSnapshot<ViewController.Section, CellModel>()
        let items = dataSource.snapshot().itemIdentifiers(inSection: .main)
        snapshot.appendSections([.main])
        snapshot.appendItems(items.shuffled())
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellModel = dataSource.itemIdentifier(for: indexPath) {
            select(cell: cellModel)
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = dataSource.itemIdentifier(for: indexPath) {
            deselect(cell: cell)
        }
    }
}
