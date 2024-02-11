//

import UIKit

class CellModel {
    let text: String
    private(set) var isSelected: Bool

    init(text: String, isSelected: Bool) {
        self.text = text
        self.isSelected = isSelected
    }

    func changeSelection(_ isSelected: Bool) {
        self.isSelected = isSelected
    }
}

//class Model {
//    private(set) var cells: [CellModel]
//
//    init() {
//
////        let cellsModels = Array
//        self.cells = cells
//    }
//
//    func select(row: Int) {
//        cells[row].changeSelection(true)
//        let cell = cells.remove(at: row)
//        cells.insert(cell, at: 0)
//    }
//
//    func deselect(row: Int) {
//        cells[row].changeSelection(false)
//    }
//
//    func shuffle() {
//        cells.shuffle()
//    }
//}

class ViewController: UIViewController {
    private let table: UITableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupNavigationController()
        setupTable()
    }

    private func setupNavigationController() {
        title = "Task 4"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Shuffle", style: .plain, target: self, action: #selector(shuffle)
        )
    }

    @objc
    private func shuffle() {
        for index in 0..<table.numberOfRows(inSection: 0) {
            table.moveRow(at: IndexPath(item: index, section: 0), to: IndexPath(item: Int.random(in: 0..<table.numberOfRows(inSection: 0)), section: 0))
        }
    }

    private func setupTable() {
        view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        table.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        table.delegate = self
        table.dataSource = self
        table.allowsMultipleSelection = true
        table.register(Cell.self, forCellReuseIdentifier: Cell.describing)
    }


}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? Cell else {
            assertionFailure("Can't dequeue as Cell")
            return
        }
        cell.setSelection(isSelected: true)
        tableView.moveRow(at: indexPath, to: IndexPath(item: 0, section: 0))
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? Cell else {
            assertionFailure("Can't dequeue as Cell")
            return
        }
        cell.setSelection(isSelected: false)
    }
}

extension ViewController: UITableViewDataSource {
//tableviewselect

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.describing, for: indexPath) as? Cell else {
            assertionFailure("Can't dequeue as Cell")
            return UITableViewCell()
        }
        cell.setup(indexPath: indexPath)
        return cell
    }
    

}

class Cell: UITableViewCell {
    private let label: UILabel = UILabel()
    private let selectedIcon: UIImageView = UIImageView(image: UIImage(systemName: "checkmark"))

    private var firstIndexPath: IndexPath? {
        didSet {
            guard let firstIndexPath else {
                assertionFailure("Don't set firstIndexPath to nil")
                return
            }
            label.text = String(firstIndexPath.row)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setlayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setlayout() {
        selectionStyle = .none

        addSubview(label)
        addSubview(selectedIcon)
        label.translatesAutoresizingMaskIntoConstraints = false
        selectedIcon.translatesAutoresizingMaskIntoConstraints = false

        selectedIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0).isActive = true
        selectedIcon.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        selectedIcon.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        selectedIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.0).isActive = true
        label.trailingAnchor.constraint(equalTo: selectedIcon.leadingAnchor, constant: 8.0).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    func setup(indexPath: IndexPath) {
        if firstIndexPath == nil {
            firstIndexPath = indexPath
            setSelection(isSelected: isSelected)
        }
    }

    func setSelection(isSelected: Bool) {
        selectedIcon.isHidden = !isSelected
    }
}

extension UIView {
    internal class var describing: String {
        return String(describing: self)
    }
}
