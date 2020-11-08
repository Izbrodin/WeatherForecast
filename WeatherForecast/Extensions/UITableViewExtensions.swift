import UIKit

extension UITableView {

    func register(cellClass: UITableViewCell.Type) {
        let name = String(describing: cellClass)
        self.register(UINib(nibName: name, bundle: Bundle.main), forCellReuseIdentifier: name)
    }

    func dequeueReusableCell<T>(for indexPath: IndexPath) -> T where T: UITableViewCell {
        let typeName = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: typeName, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable Table View Cell with type \"\(typeName)\"")
        }
        return cell
    }

    func register(headerClass: UITableViewHeaderFooterView.Type) {
        let name = String(describing: headerClass)
        self.register(UINib(nibName: name, bundle: nil), forHeaderFooterViewReuseIdentifier: name)
    }

    func dequeueReusableHeaderFooterView<T>() -> T where T: UITableViewHeaderFooterView {
        let typeName = String(describing: T.self)
        guard let headerFooterView = self.dequeueReusableHeaderFooterView(withIdentifier: typeName) as? T else {
            fatalError("Unable to dequeueReusableHeaderFooterView with type \"\(typeName)\"")
        }
        return headerFooterView
    }
}
