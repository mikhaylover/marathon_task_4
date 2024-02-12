//

import UIKit

class Cell: UITableViewCell {
    private let label: UILabel = UILabel()
    private let selectedIcon: UIImageView = UIImageView(image: UIImage(systemName: "checkmark"))

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

    func setup(model: CellModel) {
        label.text = String(model.text)
        setSelectionStatus(isSelected: model.selectionStatus)
    }

    func setSelectionStatus(isSelected: Bool) {
        selectedIcon.isHidden = !isSelected
    }
}
