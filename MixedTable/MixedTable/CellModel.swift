//

import Foundation

class CellModel: Hashable {
    let text: String
    var selectionStatus: Bool

    init(text: String, selectionStatus: Bool) {
        self.text = text
        self.selectionStatus = selectionStatus
    }

    public func hash(into hasher: inout Hasher) {
         hasher.combine(ObjectIdentifier(self))
    }

    static func == (lhs: CellModel, rhs: CellModel) -> Bool {
        lhs.text == rhs.text
    }
}
